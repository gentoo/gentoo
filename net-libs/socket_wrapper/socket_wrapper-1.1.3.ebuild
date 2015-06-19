# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/socket_wrapper/socket_wrapper-1.1.3.ebuild,v 1.1 2015/03/08 13:09:51 polynomial-c Exp $

EAPI=5

inherit cmake-utils multilib-minimal

DESCRIPTION="A library passing all socket communications through unix sockets"
HOMEPAGE="https://cwrap.org/socket_wrapper.html"
SRC_URI="ftp://ftp.samba.org/pub/cwrap/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND=""
RDEPEND="${DEPEND}"

multilib_src_configure() {
	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile
}

multilib_src_install() {
	cmake-utils_src_install
}
