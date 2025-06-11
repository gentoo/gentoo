# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake vcs-snapshot

MY_COMMIT="1e158fb20108058dbd62bd51d8e8c003c0a48717"
DESCRIPTION="Use external locker as X screen saver"
HOMEPAGE="https://bitbucket.org/raymonad/xss-lock"
SRC_URI="https://bitbucket.org/raymonad/xss-lock/get/${MY_COMMIT}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+man"

RDEPEND="dev-libs/glib:2
	x11-libs/libxcb
	x11-libs/xcb-util"
DEPEND="${RDEPEND}"
BDEPEND="man? ( dev-python/docutils )"

PATCHES=( "${FILESDIR}"/${P}-cmake4.patch )

src_install() {
	cmake_src_install

	dodoc -r "${ED}"/usr/share/doc/${PN}/.
	rm -r "${ED}"/usr/share/doc/${PN} || die
}
