# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="A tool for monitoring, capturing and storing TCP connections flows"
HOMEPAGE="https://github.com/simsong/tcpflow https://packages.qa.debian.org/t/tcpflow.html"

SRC_URI="
	https://api.github.com/repos/simsong/be13_api/tarball/c43e4596378d7ca7d7f44c2bd9c89b3888b5fcdf -> be13_api-20181010.tar.gz
	https://api.github.com/repos/simsong/dfxml/tarball/7d11eaa7da8d31f588ce8aecb4b4f5e7e8169ba6 -> dfxml-20170921.tar.gz
	https://github.com/simsong/tcpflow/archive/${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
SLOT=0
IUSE="cairo test"

RDEPEND="
	dev-db/sqlite:3
	dev-lang/python:2.7=
	dev-libs/boost:=
	dev-libs/openssl:=
	media-gfx/exiv2:=
	net-libs/http-parser:=
	net-libs/libpcap
	sys-libs/libcap-ng
	sys-libs/zlib:=
	cairo? (
		x11-libs/cairo
	)"

DEPEND="${RDEPEND}
	test? ( sys-apps/coreutils )"

S="${WORKDIR}"/${PN}-${P}

src_prepare() {
	eapply "${FILESDIR}"/${P}-gentoo.patch
	eapply "${FILESDIR}"/${P}-libcapng.patch

	mv "${WORKDIR}"/simsong-be13_api-c43e459/* src/be13_api/ || die
	mv "${WORKDIR}"/simsong-dfxml-7d11eaa/* src/dfxml/ || die

	eautoreconf
	default
}

src_configure() {
	append-cxxflags -fpermissive
	econf $(usex cairo --enable-cairo=true --enable-cairo=false)
}
