# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cannadic.eclass
# @MAINTAINER:
# cjk@gentoo.org
# @AUTHOR:
# Mamoru KOMACHI <usata@gentoo.org>
# @SUPPORTED_EAPIS: 7
# @BLURB: Function for Canna compatible dictionaries
# @DESCRIPTION:
# The cannadic eclass is used for installation and setup of Canna
# compatible dictionaries.

case ${EAPI} in
	7) ;;
	*) die "EAPI=${EAPI:-0} is not supported" ;;
esac

EXPORT_FUNCTIONS src_install pkg_postinst pkg_postrm

if [[ -z ${_CANNADIC_ECLASS} ]]; then
_CANNADIC_ECLASS=1

SRC_URI="mirror://gentoo/${P}.tar.gz"

# You don't need to modify these
readonly _CANNADIC_CANNA_DIR="/var/lib/canna/dic/canna"
readonly _CANNADIC_DICS_DIR="/var/lib/canna/dic/dics.d"

# @FUNCTION: cannadic-install
# @DESCRIPTION:
# Installs dictionaries to ${EPREFIX}/var/lib/canna/dic/canna
cannadic-install() {
	insinto ${_CANNADIC_CANNA_DIR}
	insopts -m 0664 -o bin -g bin
	doins "${@}"
}

# @FUNCTION: dicsdir-install
# @DESCRIPTION:
# Installs dics.dir from ${DICSDIRFILE}
dicsdir-install() {
	insinto ${_CANNADIC_DICS_DIR}
	doins ${DICSDIRFILE}
}

# @FUNCTION: cannadic_src_install
# @DESCRIPTION:
# Installs all dictionaries under ${WORKDIR}
# plus dics.dir and docs
cannadic_src_install() {
	keepdir ${_CANNADIC_CANNA_DIR}
	fowners bin:bin ${_CANNADIC_CANNA_DIR}
	fperms 0775 ${_CANNADIC_CANNA_DIR}

	local f
	for f in *.c[btl]d *.t; do
		if [[ -s ${f} ]]; then
			cannadic-install "${f}"
		fi
	done 2> /dev/null

	dicsdir-install

	einstalldocs
}

# @FUNCTION: update-cannadic-dir
# @DESCRIPTION:
# Updates dics.dir for Canna Server, script for this part taken from Debian GNU/Linux
#
#  compiles dics.dir files for Canna Server
#  Copyright 2001 ISHIKAWA Mutsumi
#  Licensed under the GNU General Public License, version 2.  See the file
#  /usr/portage/license/GPL-2 or <http://www.gnu.org/copyleft/gpl.txt>.
update-cannadic-dir() {
	einfo
	einfo "Updating dics.dir for Canna ..."
	einfo

	# write new dics.dir file in case we are interrupted
	cat <<-EOF > "${EROOT}${_CANNADIC_CANNA_DIR}"/dics.dir.update-new || die
		# dics.dir -- automatically generated file by Portage.
		# DO NOT EDIT BY HAND.
	EOF

	local f
	for f in "${EROOT}${_CANNADIC_DICS_DIR}"/*.dics.dir; do
		echo "# ${f}" >> "${EROOT}${_CANNADIC_CANNA_DIR}"/dics.dir.update-new || die
		cat "${f}" >> "${EROOT}${_CANNADIC_CANNA_DIR}"/dics.dir.update-new || die
		einfo "Added ${f}."
	done

	mv "${EROOT}${_CANNADIC_CANNA_DIR}"/dics.dir.update-new \
		"${EROOT}${_CANNADIC_CANNA_DIR}"/dics.dir || die

	einfo
	einfo "Done."
	einfo
}

# @FUNCTION: cannadic_pkg_postinst
# @DESCRIPTION:
# Updates dics.dir and print out notice after install
cannadic_pkg_postinst() {
	debug-print-function ${FUNCNAME} "${@}"

	update-cannadic-dir

	einfo "Please restart cannaserver for changes to propagate."
	einfo "You need to modify your config file (~/.canna) to enable dictionaries."

	if [[ -n ${CANNADICS} ]]; then
		einfo "e.g) add"
		einfo
		einfo "  $(IFS=' ' ; echo ${CANNADICS[*]})"
		einfo
		einfo "to section use-dictionary()."
		einfo "For details, see documents under ${EROOT}/usr/share/doc/${PF}."
	fi

	einfo "If you do not have ~/.canna, you can find sample files in ${EROOT}/usr/share/canna."
	ewarn "If you are upgrading from existing dictionary, you may need to recreate"
	ewarn "user dictionary if you have one."
}

# @FUNCTION: cannadic_pkg_postrm
# @DESCRIPTION:
# Updates dics.dir and print out notice after uninstall
cannadic_pkg_postrm() {
	debug-print-function ${FUNCNAME} "${@}"

	update-cannadic-dir

	einfo "Please restart cannaserver for changes to propagate."
	einfo "and modify your config file (~/.canna) to disable dictionary."

	if [[ -n ${CANNADICS} ]]; then
		einfo "e.g) delete"
		einfo
		einfo "  $(IFS=' ' ; echo ${CANNADICS[*]})"
		einfo
		einfo "from section use-dictionary()."
	fi

	einfo
}

fi
