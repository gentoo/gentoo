# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Password Safe in secure way with GUI interface"
HOMEPAGE="https://github.com/zdia/gorilla/wiki"
SRC_URI="https://github.com/zdia/gorilla/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	>=dev-lang/tcl-8.4.19:0
	>=dev-lang/tk-8.4.19:0
	dev-tcltk/iwidgets
	dev-tcltk/bwidget
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-script-destdir.patch
)

src_configure() {
	./configure || die "econf failed"
}

src_compile() { :; }

src_install() {
	PREFIX="/opt/${P}"

	insinto ${PREFIX}
	doins -r gorilla.tcl isaac.tcl twofish sha1 blowfish pwsafe pics

	dobin gorilla
}
