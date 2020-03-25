# Prepare
regex = ///
	# allow some space
	^\s*
	# allow potential comment characters in delimiter
	[^\n]*?
	# discover our delimiter
	(
		([^\s\d\w])  #\2
		\2{2,}  # match the above (the first character of our delimiter), 2 or more times
	) #\1
	# discover our parser (optional)
	(?:
		\x20*  # allow zero or more space characters, see https://github.com/jashkenas/coffee-script/issues/2668
		(
			[a-z]+  # parser must be lowercase alpha
		)  #\3
	)?
	# discover our meta content
	(
		[\s\S]*?  # match anything/everything lazily
	) #\4
	# allow potential comment characters in delimiter
	[^\n]*?
	# match our delimiter (the first group) exactly
	\1
	# allow potential comment characters in delimiter
	[^\n]*
	# end with a newline
	\n
	///

# Export
module.exports = (content) ->
	# Normalise line endings for the web, just for convience, if it causes problems we can remove
	content = content.replace(/\r\n?/gm,'\n')

	# ensure the content ends with a newline
	if content[content.length - 1] isnt '\n'
		content += '\n'

	# Extract Meta Data
	match = regex.exec(content)
	if match
		# Prepare
		delimiter = match[1]
		parser = if typeof match[3] is 'string' then match[3].toLowerCase() else null
		header = match[4].trim()
		body = content.substring(match[0].length)

		# Parse
		return {delimiter, parser, header, body, content}
	else
		return {content}
