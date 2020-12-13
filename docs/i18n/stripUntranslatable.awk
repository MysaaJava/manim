BEGIN {
	# The current state of the parser:
	# -1 -> haven't read the first line of the new block
	# 0  -> reading the pre-comment
	# 1  -> reading the msgid
	# 2  -> reading the msgstr
	state=-1
	# The comment preceding the block
	precomment=""
	# The msgid section, containing the string to be translated
	msgidstr=""
	# The same string, but with a sharp before every newline (commented  out)
	sharpedmsgidstr=""
	# The msgstr section, containing the destination string
	msgstrstr=""
	# The same string, but with a sharp before every newline (commented out)
	sharpedmsgstrstr=""
	# Wether the block being read should be kept
	# -1 -> should keep, overridable
	# 0  -> should not keep, overridable
	# 1  -> should keep, not overridable
	acceptable=1
	# The file location of where to put everything 
	# that has been stripped out
	untranslatablefile="./untranslatable.po"
}
# This pattern matches empty lines
# The code flushes the data stored, and save
# it only if acceptable!=1
$0~/^$/ {
	if (state<=0){
		if(acceptable!=1){
			print precomment
		}else{
			print "#  Detected untranslatable text:"
			print precomment
		}
		precomment=""
	}else{
		if(acceptable==1){
			print precomment
			print msgidstr
			print msgstrstr
		}else{
			print "#  Detected untranslatable text:"
			print precomment
			print sharpedmsgidstr
			print sharpedmsgstrstr
			print precomment>>untranslatablefile
			print msgidstr>>untranslatablefile
			print msgstrstr>>untranslatablefile
		}
		# Add the newline currently parsed
		print ""
		# Re-initialisation of the variables.
		state=-1
		acceptable=-1
		precomment=""
		msgidstr=""
		msgstrstr=""
	}
}
# If the line is commented out
$0~/^#/ {
	precomment=(state==-1)?$0:precomment"\n"$0
	state=0
}
# If the line starts with "msgid"
$0~/^msgid/ {
	state=1
	msgidstr=$0
	sharpedmsgidstr="#| "$0
}
# If the line starts with msgstr
$0~/^msgstr/ {
	state=2
	msgstrstr=$0
	sharpedmsgstrstr="#| "$0
}
# If the line starts with a '"'
$0~/^\"/ {
	if(state==1){
		msgidstr=msgidstr"\n"$0
		sharpedmsgidstr=sharpedmsgidstr"\n#| "$0
	}else{
		msgstrstr=msgstrstr"\n"$0
		sharpedmsgstrstr=sharpedmsgstrstr"\n#| "$0
	}
}
# ----------------------------------------------------------------


# This code is now the part that actually selects lines to be stripped out.

state==1 {
	if($0~/^(msgid ""|"")$/){
		
	}else if($0~/^(msgid "|")((:ref:`[a-zA-Z]*`)|(:obj:)|(manim.([a-z._\\]+)"$)|(((:(mod|class|func):`\~?\.[a-zA-Z0-9._]+)`| )+))/ ) {
		acceptable=(acceptable==-1)?0:acceptable
	}else{
		acceptable=1
	}
}
#$0~/^msgid ":ref:`[a-zA-Z]*`"/ {
#	acceptable=0
#}
#$0~/^msgid ":obj:/ {
#	acceptable=0
#}
#$0~/^msgid "manim.([a-z._\\]+)"$/ {
#	acceptable=0
#}
#$0~/^msgid "((:(mod|class|func):`~\.[a-zA-Z0-9.]+)`| )+"/ {
#	acceptable=0
#}
#$0~/^"((:(mod|class|func):`~\.[a-zA-Z0-9.]+)`| )+"/ {
#	acceptable=0
#}
#$0~/^"/ 

# When the parsing is ended, print the last missing endline
END {
print ""
}
