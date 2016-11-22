# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils vcs-snapshot

DESCRIPTION="Use external locker as X screen saver"
HOMEPAGE="https://bitbucket.org/raymonad/xss-lock"
SRC_URI="https://bitbucket.org/raymonad/xss-lock/get/1e158fb20108058dbd62bd51d8e8c003c0a48717.tar.bz2 -> ${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+man"

RDEPEND="dev-libs/glib:2
	x11-libs/libxcb"
DEPEND="${RDEPEND}
	man? ( dev-python/docutils )"

src_install() {
	cmake-utils_src_install

	dodoc -r "${ED%/}/usr/share/doc/${PN}/."
	rm -r "${ED%/}/usr/share/doc/${PN}" || die
}
