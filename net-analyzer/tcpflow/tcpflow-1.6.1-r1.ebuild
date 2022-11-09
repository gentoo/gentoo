# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="A tool for monitoring, capturing and storing TCP connections flows"
HOMEPAGE="https://github.com/simsong/tcpflow"
SRC_URI="
	https://api.github.com/repos/simsong/be13_api/tarball/c81521d768bb78499c069fcd7c47adc8eee0350c -> be13_api-20170924.tar.gz
	https://api.github.com/repos/simsong/dfxml/tarball/7d11eaa7da8d31f588ce8aecb4b4f5e7e8169ba6 -> dfxml-20170921.tar.gz
	https://github.com/simsong/tcpflow/archive/refs/tags/${P}.tar.gz -> ${P}-tag.tar.gz
"
S="${WORKDIR}"/${PN}-${P}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="cairo test"
RESTRICT="!test? ( test )"

RDEPEND="dev-db/sqlite
	dev-libs/boost:=
	dev-libs/openssl:=
	net-libs/http-parser:=
	net-libs/libpcap
	sys-libs/libcap-ng
	sys-libs/zlib:=
	cairo? (
		x11-libs/cairo
	)"
DEPEND="${RDEPEND}"
BDEPEND="test? ( sys-apps/coreutils )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.0_alpha-libcapng.patch
	"${FILESDIR}"/${PN}-1.5.2-gentoo.patch
	"${FILESDIR}"/${PN}-1.6.1-wformat-security.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	append-cxxflags -fpermissive

	# Disable Python because it's Python 2.7 only, even as of 1.6.1!
	export ac_cv_header_python2_7_Python_h=no
	export ac_cv_lib_python2_7_Py_Initialize=no

	CONFIG_SHELL="${BROOT}"/bin/bash econf $(usex cairo --enable-cairo=true --enable-cairo=false)
}
