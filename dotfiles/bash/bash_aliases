# Common aliases for taskwarrior etc.

alias in='task add +in'
alias w='task add +work'
alias 1='task add +oneoff'
alias gct='git -C ~/.task commit -a -m "task" && git -C ~/.task push'
alias gpt='git -C ~/.task pull'
alias tt='taskwarrior-tui'

project () {
	# Legg til flere tasks på samme prosjekt
	while true
	do
		echo "neste task på '$1':"
		read task
		task add pro:$1 $task
	done
}
alias pro=project

webpage_title (){
	wget -qO- "$*" | hxselect -s '\n' -c 'title' >/dev/null
}

read_and_review (){
	link="$1"
	title=$(webpage_title $link)
	echo $title
	descr="\"Read and review: $title\""
	id=$(task add +next +rnr "$descr" | sed -n 's/Created task \(.*\)./\1/p')
	task "$id" annotate "$link"
}

pass_clip (){
	pass "$*" | head -1 | clip.exe
}

alias rnr=read_and_review
alias wt=webpage_title
alias pc=pass_clip
