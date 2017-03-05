# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#

inherit eutils multilib

SLOT="0"
IUSE="scsh"

scsh_scsh_path() {
	echo /usr/$(get_libdir)/scsh
}

set_layout() {
	if use scsh; then
		SCSH_LAYOUT=scsh
	else
		ewarn "No layout was specified via USE, defaulting to FHS."
		SCSH_LAYOUT=fhs
	fi
	export SCSH_LAYOUT
}

set_path_variables() {
	SCSH_VERSION="$(best_version 'app-shells/scsh')"
	SCSH_MV="${SCSH_VERSION%*.*}"
	SCSH_MV="${SCSH_MV//app-shells\/scsh-}"
	export SCSH_VERSION SCSH_MV

	case ${SCSH_LAYOUT} in
		fhs)
			SCSH_PREFIX=/usr
			SCSH_MODULES_PATH=/usr/share/scsh-${SCSH_MV}/modules
			;;
		scsh)
			SCSH_PREFIX=/usr/$(get_libdir)/scsh/modules
			SCSH_MODULES_PATH=/usr/$(get_libdir)/scsh/modules/${SCSH_MV}
			;;
	esac
	export SCSH_PREFIX SCSH_MODULES_PATH

	SCSH_LIB_DIRS='"'${SCSH_MODULES_PATH}'"'" "'"'$(scsh_scsh_path)'"'" "'"'.'"'
	export SCSH_LIB_DIRS
}

scsh_src_unpack() {
	set_layout
	set_path_variables
	einfo "Using ${SCSH_LAYOUT} layout"
	unpack ${A}
}

scsh_get_layout_conf() {
	SCSH_LAYOUT_CONF=" --build ${CHOST}
		--force
		--layout ${SCSH_LAYOUT}
		--prefix ${SCSH_PREFIX}
		--no-user-defaults
		--dest-dir ${D}"
	export SCSH_LAYOUT_CONF
}

scsh_src_compile() {
	scsh_get_layout_conf
}

scsh_src_install() {
	dodir ${SCSH_MODULES_PATH}
	scsh-install-pkg ${SCSH_LAYOUT_CONF} || die "./scsh-install-pkg failed"
}

EXPORT_FUNCTIONS src_unpack src_compile src_install
