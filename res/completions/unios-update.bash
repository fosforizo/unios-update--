_unios-update() {
	local arg="${2}"
	local -a opts
	opts=('-c --check
	       -l --list
	       -d --devel
	       -n --news
	       -s --services
	       -D --debug
	       --gen-config
	       --show-config
	       --edit-config
	       --tray
	       -h --help
	       -V --version')

	COMPREPLY=( $(compgen -W "${opts[*]}" -- "${arg}") )
}

complete -F _unios-update unios-update
