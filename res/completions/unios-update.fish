complete -c unios-update -f

complete -c unios-update -s c -l check -d 'Check for available updates'
complete -c unios-update -s l -l list -d 'Display the list of pending updates'
complete -c unios-update -s d -l devel -d 'Include AUR development packages updates'
complete -c unios-update -s n -l news -d 'Display latest Arch news'
complete -c unios-update -s s -l services -d 'Check for services requiring a post upgrade restart'
complete -c unios-update -s D -l debug -d 'Display debug traces'
complete -c unios-update -l gen-config -d 'Generate a default / example configuration file'
complete -c unios-update -l show-config -d 'Display the current configuration file'
complete -c unios-update -l edit-config -d 'Edit the current configuration file'
complete -c unios-update -l tray -d 'Launch the UniOS-Update systray applet'
complete -c unios-update -s h -l help -d 'Display the help message'
complete -c unios-update -s V -l version -d 'Display version information'
