# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tk GUI console"
HOMEPAGE="http://tkcon.sourceforge.net/"
SRC_URI="https://github.com/wjoye/${PN}/archive/v${PV}.tar.gz ->
	${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
IUSE="doc"

DEPEND="dev-lang/tk:*"
RDEPEND="${DEPEND}"

RESTRICT="test"

src_prepare() {
	default
	mv docs/changes.txt CHANGES
}

src_install() {
	local tclver="$(echo 'puts $tcl_version' | tclsh)"
	local instdir=/usr/$(get_libdir)/tcl${tclver}/${PN}$(ver_cut 1-2)
	dodir ${instdir}
	cp -pP pkgIndex.tcl tkcon.tcl "${D}"${instdir} || die
	dodir /usr/bin
	dosym ${instdir}/tkcon.tcl /usr/bin/tkcon
	if use doc; then
		HTML_DOCS=( docs/* )
	fi
	einstalldocs
}
