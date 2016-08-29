# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit versionator eutils

#version magic thanks to masterdriverz and UberLord using bash array instead of tr
trarr="0abcdefghi"
MY_PV="$(get_version_component_range 1)${trarr:$(get_version_component_range 2):1}$(get_version_component_range 3)"

MY_P=${PN}-${MY_PV}
S=${WORKDIR}/${PN}
DESCRIPTION="library providing functions for Scheme implementations"
SRC_URI="http://swiss.csail.mit.edu/ftpdir/scm/${MY_P}.zip"

HOMEPAGE="http://swiss.csail.mit.edu/~jaffer/SLIB"

SLOT="0"
LICENSE="public-domain BSD"
KEYWORDS="alpha amd64 ia64 ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="" #test"

#unzip for unpacking
RDEPEND=""
DEPEND="app-arch/unzip"
#		test? ( dev-scheme/scm )"

INSTALL_DIR="/usr/share/slib/"

_fix_txi_file() {
	local inplace_filename="${1}"
	local tempfile="$(emktemp)"
	awk -f "${FILESDIR}"/slib-3.2.2-fix-texinfo.awk < "${inplace_filename}" > "${tempfile}"
	mv "${tempfile}" "${inplace_filename}" || die
}

src_prepare() {
	sed "s:prefix = /usr/local/:prefix = ${ED}/usr/:" -i Makefile || die
	sed 's:libdir = $(exec_prefix)lib/:libdir = $(exec_prefix)share/:' -i Makefile || die
	sed 's:man1dir = $(prefix)man/:man1dir = $(prefix)/share/man/:' -i Makefile || die
	sed 's:infodir = $(prefix)info/:infodir = $(prefix)share/info/:' -i Makefile || die

	sed 's:echo SCHEME_LIBRARY_PATH=$(libslibdir)  >> $(bindir)slib:echo SCHEME_LIBRARY_PATH='"${EPREFIX}"'/usr/share/slib/ >> $(bindir)slib:' -i Makefile || die

#	diff -u Makefile.old Makefile

	sed 's:(lambda () "/usr/local/share/gambc/")):(lambda () "'"${EPREFIX}"'/usr/share/gambit")):' -i gambit.init || die

	einfo "Fixing Texinfo files..."
	for i in *.txi *.texi ; do
		_fix_txi_file "${i}" || die
	done
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	emake infoz || die "infoz failed"
	emake install || die "install failed"

	dodoc ANNOUNCE ChangeLog FAQ README || die
	dodir /usr/share/gambit/
	more_install
}

more_install() {
	dosym ${INSTALL_DIR} /usr/share/guile/slib # link from guile dir
	dosym ${INSTALL_DIR} /usr/lib/slib
	dodir /etc/env.d/ && echo "SCHEME_LIBRARY_PATH=\"${EPREFIX}${INSTALL_DIR}\"" > "${ED}"/etc/env.d/50slib

	mkdir "${S}"/installers
	pushd installers; make_installers; popd
	dosbin installers/* || die
}

pkg_postinst() {
	[ "${ROOT}" == "/" ] && pkg_config
}

IMPLEMENTATIONS="bigloo drscheme elk gambit guile scm" # mit-scheme

pkg_config() {
	for impl in ${IMPLEMENTATIONS}; do
		install_slib ${impl}
#		echo '(slib:report-version)' | slib ${impl}
	done
}

make_load_expression() {
	echo "(load \\\"${EPREFIX}${INSTALL_DIR}$1.init\\\")"
}

make_installers()
{
	PROGRAM="(require 'new-catalog) (slib:report-version)"

	bigloo_install_command="bigloo -s -eval \"(begin "$(make_load_expression bigloo)" ${PROGRAM} (exit))\""
	drscheme_install_command="mzscheme -vme \"(begin $(make_load_expression mzscheme) ${PROGRAM})\""
	elk_install_command="echo \"$(make_load_expression elk) ${PROGRAM}\" | elk -l -"
	gambit_install_command="gambit-interpreter -e \"$(make_load_expression gambit) ${PROGRAM}\""
#	guile_install_command="guile -c \"$(make_load_expression guile) ${PROGRAM}\""
	guile_install_command="guile -c \"(use-modules (ice-9 slib)) ${PROGRAM}\""
	#variable names may not contain hyphens (-)
	mitscheme_install_command="echo \"(set! load/suppress-loading-message? #t) $(make_load_expression mitscheme) ${PROGRAM}\" | mit-scheme --batch-mode"
	echo ${mitscheme_install_command}
	scm_install_command="scm -e \"${PROGRAM}\""

	for impl in ${IMPLEMENTATIONS}; do
		command_var=${impl//-/}_install_command
		make_installer ${impl} "${!command_var}"
	done
}

make_installer() {
	echo $2 > install_slib_for_${1//-/}
}

install_slib() {
	if has_version dev-scheme/$1; then
		script=install_slib_for_${1//-/}
		einfo "Registering slib with $1..."
#		echo running: $(cat "${EPREFIX}"/usr/sbin/${script})
		$script
	else
		einfo "$1 not installed, not registering..."
	fi
}
