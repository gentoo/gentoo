# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop texlive-common

DESCRIPTION="GUI and command-line converter for [e]ps and pdf"
HOMEPAGE="http://tex.aanhet.net/epspdf/"
# http://tex.aanhet.net/epspdf/${PN}.${PV}.tgz
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}.zip"
S="${WORKDIR}"/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc tk"

RDEPEND="!<dev-texlive/texlive-pictures-2011-r1
	>=dev-texlive/texlive-basic-2011
	app-text/ghostscript-gpl
	tk? ( dev-lang/tk )"
BDEPEND="app-arch/unzip
	sys-apps/texinfo"

src_compile() {
	cd doc || die
	makeinfo epspdf || die
}

src_install() {
	exeinto /usr/share/${PN}
	doexe epspdf.tlu

	insinto /usr/share/${PN}

	if use tk ; then
		doins epspdf.help doc/images/epspdf.png
		doexe epspdftk.tcl
	fi

	dobin_texmf_scripts ${PN}/epspdf.tlu
	use tk && dobin_texmf_scripts ${PN}/epspdftk.tcl

	doinfo doc/epspdf.info
	dodoc doc/Changelog
	if use doc ; then
		dodoc doc/epspdf.pdf
		dodoc -r doc
	fi

	# Give it a .desktop
	if use tk; then
		make_desktop_entry epspdftk epspdftk "${EPREFIX}/usr/share/${PN}/epspdf.png" "Graphics;ImageProcessing"
	fi
}
