const docmatter = require('./')
const yamljs = require('yamljs')

function parse (input) {
	const matter = docmatter(input)

	// if no front matter: {content}
	if (!matter.header) return { content: matter.content.trim() }

	// if front matter: {delimiter, parser, header, body, content}
	let data = null
	switch (matter.parser) {
		case 'json':
			if (matter.header[0] === '{' && matter.header[matter.header.length - 1] === '}') {
				data = JSON.parse(matter.header)
			}
			else {
				data = JSON.parse(`{${matter.header}}`)
			}
			break;


		case 'yaml':
		default:
			data = yamljs.parse(
				matter.header.replace(/\t/g, '    ')  // YAML doesn't support tabs that well
			)
			break;
	}
	return { data, content: matter.body.trim() }
}


// no content and only front matter
console.log(parse(`
---
title: Hello World
---
`))
// => { data: { title: 'Hello World' }, content: '' }


// markdown content with default front matter
console.log(parse(`
---
title: Hello World
---

**hello world**
`))
// => { data: { title: 'Hello World' }, content: '**hello world**' }


// markdown content with json front matter
console.log(parse(`
--- json
"title": "Hello World"
---

**hello world**
`))
// => { data: { title: 'Hello World' }, content: '**hello world**' }


// markdown content with no front matter
console.log(parse(`
**hello world**
`))
// => { content: '**hello world**' }


// javascript content with default front matter
console.log(parse(`
/***
minify: true
***/

alert('Hello World')
`))
// => { data: { minify: true }, content: 'alert(\'Hello World\')' }
