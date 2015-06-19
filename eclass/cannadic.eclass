# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/cannadic.eclass,v 1.17 2012/09/15 16:16:53 zmedico Exp $

# @ECLASS: cannadic.eclass
# @AUTHOR:
# Original author: Mamoru KOMACHI <usata@gentoo.org>
# @BLURB: Function for Canna compatible dictionaries
# @DESCRIPTION:
# The cannadic eclass is used for installation and setup of Canna
# compatible dictionaries within the Portage system.


EXPORT_FUNCTIONS src_install pkg_setup pkg_postinst pkg_postrm

IUSE=""

HOMEPAGE="http://canna.sourceforge.jp/"		# you need to change this!
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"

S="${WORKDIR}"

DICSDIRFILE="${FILESDIR}/*.dics.dir"
CANNADICS="${CANNADICS}"			# (optional)
DOCS="README*"

# You don't need to modify these
#local cannadir dicsdir
cannadir="${ROOT}/var/lib/canna/dic/canna"
dicsdir="${ROOT}/var/lib/canna/dic/dics.d"

# @FUNCTION: cannadic_pkg_setup
# @DESCRIPTION:
# Sets up cannadic dir
cannadic_pkg_setup() {

	keepdir $cannadir
	fowners bin:bin $cannadir
	fperms 0775 $cannadir
}

# @FUNCTION: cannadic-install
# @DESCRIPTION:
# Installs dictionaries to cannadir
cannadic-install() {

	insinto $cannadir
	insopts -m0664 -o bin -g bin
	doins "$@"
}

# @FUNCTION: dicsdir-install
# @DESCRIPTION:
# Installs dics.dir from ${DICSDIRFILE}
dicsdir-install() {

	insinto ${dicsdir}
	doins ${DICSDIRFILE}
}

# @FUNCTION: cannadic_src_install
# @DESCRIPTION:
# Installs all dictionaries under ${WORKDIR}
# plus dics.dir and docs
cannadic_src_install() {

	for f in *.c[btl]d *.t ; do
		cannadic-install $f
	done 2>/dev/null

	dicsdir-install || die

	dodoc ${DOCS}
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
	cat >${cannadir}/dics.dir.update-new<<-EOF
	# dics.dir -- automatically generated file by Portage.
	# DO NOT EDIT BY HAND.
	EOF

	for file in ${dicsdir}/*.dics.dir ; do
		echo "# $file" >> ${cannadir}/dics.dir.update-new
		cat $file >> ${cannadir}/dics.dir.update-new
		einfo "Added $file."
	done

	mv ${cannadir}/dics.dir.update-new ${cannadir}/dics.dir

	einfo
	einfo "Done."
	einfo
}

# @FUNCTION: cannadic_pkg_postinst
# @DESCRIPTION:
# Updates dics.dir and print out notice after install
cannadic_pkg_postinst() {
	update-cannadic-dir
	einfo
	einfo "Please restart cannaserver to fit the changes."
	einfo "You need to modify your config file (~/.canna) to enable dictionaries."

	if [ -n "${CANNADICS}" ] ; then
		einfo "e.g) add $(for d in ${CANNADICS}; do
				echo -n "\"$d\" "
				done)to section use-dictionary()."
		einfo "For details, see documents under /usr/share/doc/${PF}"
	fi

	einfo "If you do not have ~/.canna, you can find sample files in /usr/share/canna."
	ewarn "If you are upgrading from existing dictionary, you may need to recreate"
	ewarn "user dictionary if you have one."
	einfo
}

# @FUNCTION: cannadic_pkg_postrm
# @DESCRIPTION:
# Updates dics.dir and print out notice after uninstall
cannadic_pkg_postrm() {
	update-cannadic-dir
	einfo
	einfo "Please restart cannaserver to fit changes."
	einfo "and modify your config file (~/.canna) to disable dictionary."

	if [ -n "${CANNADICS}" ] ; then
		einfo "e.g) delete $(for d in ${CANNADICS}; do
				echo -n "\"$d\" "
				done)from section use-dictionary()."
	fi

	einfo
}
