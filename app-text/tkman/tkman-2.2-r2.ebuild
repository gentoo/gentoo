# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Graphical, hypertex man and info page browser"
HOMEPAGE="https://sourceforge.net/projects/tkman/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND="
	>=app-text/rman-3.1
	>=dev-lang/tcl-8.4:0
	>=dev-lang/tk-8.4:0
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2-gentoo.diff \
	"${FILESDIR}"/${PN}-CVE-2008-5137.diff
)

src_install() {
	local DOCS=( ANNOUNCE-tkman.txt CHANGES README-tkman )
	local HTML_DOCS=( manual.html )

	dodir /usr/bin
	default

	doicon contrib/TkMan.gif

	domenu "${FILESDIR}"/tkman.desktop
}
