# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/uid_wrapper/uid_wrapper-1.1.0.ebuild,v 1.2 2015/03/08 14:25:15 polynomial-c Exp $

EAPI=5

inherit cmake-utils multilib-minimal

DESCRIPTION="A wrapper to fake privilege separation"
HOMEPAGE="https://cwrap.org/uid_wrapper.html"
SRC_URI="ftp://ftp.samba.org/pub/cwrap/${P}.tar.gz"
LICENSE="GPL-3"
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
