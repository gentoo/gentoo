# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xdo/xdo-0.4.ebuild,v 1.1 2015/03/08 17:00:53 radhermit Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Small X utility to perform elementary actions on windows"
HOMEPAGE="https://github.com/baskerville/xdo/"
SRC_URI="https://github.com/baskerville/xdo/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="x11-libs/libxcb
	x11-libs/xcb-util-wm"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e '/CFLAGS += -Os/d' \
		-e '/LDFLAGS += -s/d' \
		-i Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" PREFIX=/usr
}

src_install() {
	emake PREFIX=/usr DESTDIR="${D}" install
}
