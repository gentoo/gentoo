# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic systemd

DESCRIPTION="Server for the GtkAtlantic board game"
HOMEPAGE="https://gtkatlantic.gradator.net"
SRC_URI="https://download.tuxfamily.org/gtkatlantic/monopd/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd"

RDEPEND="
	systemd? ( sys-apps/systemd )
"

DEPEND="
	${RDEPEND}
	>=dev-cpp/muParser-2
	dev-libs/utfcpp
"

PATCHES=(
	"${FILESDIR}"/${P}-fixes.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cppflags -I"${ESYSROOT}/usr/include/utf8cpp"
	econf $(use_with systemd systemd-daemon)
}

src_install() {
	default
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	use systemd && systemd_dounit doc/systemd/${PN}.s*
}
