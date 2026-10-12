export UNIOS_UPDATE_LIBDIR="${PWD}/src/lib"

@test "version" {
	XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}" src/unios-update.sh --version
}

@test "help" {
	XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}" src/unios-update.sh --help
}
