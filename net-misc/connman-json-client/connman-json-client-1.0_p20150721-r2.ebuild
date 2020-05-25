# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools vcs-snapshot
COMMIT="3c34b2ee62d2e188090d20e7ed2fd94bab9c47f2"

DESCRIPTION="An ncurses UI for connman"
HOMEPAGE="https://github.com/eurogiciel-oss/connman-json-client"
SRC_URI="https://github.com/eurogiciel-oss/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/json-c:0=
	>=sys-apps/dbus-1.4
	sys-libs/ncurses:0"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/cjc-fix-for-json-0.14.patch )

src_prepare() {
	sed -i -e '/^AM_CFLAGS/ s/ -Werror$//' Makefile.am || die
	default
	eautoreconf
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	default
	dobin connman_ncurses
}
