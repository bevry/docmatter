# Import
joe = require('joe')
{deepEqual} = require('assert-helpers')
docmatter = require('../')

# Test
joe.suite 'docmatter', (suite,test) ->
	test 'only front matter with no newline', ->
		result = docmatter('''
			---
			only: true
			---
			''')
		deepEqual(result, {
			delimiter: '---',
			parser: null,
			header: 'only: true',
			body: '',
			content: '---\nonly: true\n---\n'
		})

	test 'only front matter with newline', ->
		result = docmatter('''
			---
			only: true
			---

			''')
		deepEqual(result, {
			delimiter: '---',
			parser: null,
			header: 'only: true',
			body: '',
			content: '---\nonly: true\n---\n'
		})

	test 'markdown content with default front matter', ->
		result = docmatter('''
			---
			title: Hello World
			---

			**hello world**
			''')
		deepEqual(result, {
			delimiter: '---',
			parser: null,
			header: 'title: Hello World',
			body: '\n**hello world**\n',
			content: '---\ntitle: Hello World\n---\n\n**hello world**\n'
		})

	test 'markdown content with json front matter', ->
		result = docmatter('''
			--- json
			"title": "Hello World"
			---

			**hello world**
			''')
		deepEqual(result, {
			delimiter: '---',
			parser: 'json',
			header: '"title": "Hello World"',
			body: '\n**hello world**\n',
			content: '--- json\n"title": "Hello World"\n---\n\n**hello world**\n'
		})

	test 'markdown content with no front matter', ->
		result = docmatter('''
			**hello world**
			''')
		deepEqual(result, {
			content: '**hello world**\n'
		})

	test 'javascript content with default front matter', ->
		result = docmatter('''
			/***
			minify: true
			***/

			alert('Hello World')
			''')
		deepEqual(result, {
			delimiter: '***',
			parser: null,
			header: 'minify: true',
			body: "\nalert('Hello World')\n",
			content:  '/***\nminify: true\n***/\n\nalert(\'Hello World\')\n'
		})
