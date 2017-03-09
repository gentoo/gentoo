# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils readme.gentoo-r1 systemd

DESCRIPTION="simple fan control program for thinkpads"
HOMEPAGE="http://thinkfan.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="atasmart"

DEPEND="atasmart? ( dev-libs/libatasmart )"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake-utils_src_prepare

	sed -e "s:#!/sbin/runscript:#!/sbin/openrc-run:" \
		-i rcscripts/thinkfan.gentoo

	sed -e "s:share/doc/${PN}:share/doc/${PF}:" \
	    -e "s:thinkfan.1:src/thinkfan.1:" \
		-i CMakeLists.txt
}

src_configure() {
	local mycmakeargs+=(
		"-DCMAKE_BUILD_TYPE:STRING=Debug"
		"-DUSE_ATASMART=$(usex atasmart)"
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
