# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit texlive-common eutils

DESCRIPTION="GUI and command-line converter for [e]ps and pdf"
HOMEPAGE="http://tex.aanhet.net/epspdf/"
SRC_URI="http://tex.aanhet.net/epspdf/${PN}.${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc tk"

DEPEND="sys-apps/texinfo"
RDEPEND="!<dev-texlive/texlive-pictures-2011-r1
	>=dev-texlive/texlive-basic-2011
	app-text/ghostscript-gpl
	tk? ( dev-lang/tk )"

S=${WORKDIR}/${PN}
INSTALLDIR=/usr/share/${PN}
FILES="epspdf.tlu"
TKFILES="epspdf.help doc/images/epspdf.png epspdftk.tcl"

src_compile() {
	cd doc
	makeinfo epspdf || die
}

src_install() {
	dodir ${INSTALLDIR}
	cp -p ${FILES} "${ED}/${INSTALLDIR}" || die
	if use tk ; then
		cp -p ${TKFILES} "${ED}/${INSTALLDIR}" || die
	fi
	dobin_texmf_scripts "${PN}/epspdf.tlu"
	use tk && dobin_texmf_scripts "${PN}/epspdftk.tcl"

	doinfo doc/epspdf.info
	dodoc doc/Changelog
	if use doc ; then
		dodoc doc/epspdf.pdf
		dohtml -r doc
	fi

	# give it a .desktop
	if use tk; then
		make_desktop_entry epspdftk epspdftk "${INSTALLDIR}/epspdf.png" "Graphics;ImageProcessing"
	fi
}
