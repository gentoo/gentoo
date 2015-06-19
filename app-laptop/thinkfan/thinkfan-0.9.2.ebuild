# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/thinkfan/thinkfan-0.9.2.ebuild,v 1.1 2014/07/21 15:10:29 xmw Exp $

EAPI=5

inherit cmake-utils readme.gentoo systemd

DESCRIPTION="simple fan control program for thinkpads"
HOMEPAGE="http://thinkfan.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="atasmart"

DEPEND="atasmart? ( dev-libs/libatasmart )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_prepare() {
	sed -e "s:share/doc/${PN}:share/doc/${P}:" \
		-i CMakeLists.txt
}

src_configure() {
	mycmakeargs+=(
		"-DCMAKE_BUILD_TYPE:STRING=Debug"
		"$(cmake-utils_use_use atasmart ATASMART)"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	newinitd rcscripts/${PN}.gentoo ${PN}
	systemd_dounit rcscripts/${PN}.service

	readme.gentoo_create_doc
}

DOC_CONTENTS="Please read the documentation and copy an
appropriate file to /etc/thinkfan.conf."
