# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
inherit autotools flag-o-matic python-single-r1

DESCRIPTION="A tool for monitoring, capturing and storing TCP connections flows"
HOMEPAGE="https://github.com/simsong/tcpflow"
SRC_URI="
	https://api.github.com/repos/simsong/be13_api/tarball/c81521d768bb78499c069fcd7c47adc8eee0350c -> be13_api-20170924.tar.gz
	https://api.github.com/repos/simsong/dfxml/tarball/7d11eaa7da8d31f588ce8aecb4b4f5e7e8169ba6 -> dfxml-20170921.tar.gz
	https://dev.gentoo.org/~jer/be13_api-20170924.tar.gz
	https://dev.gentoo.org/~jer/dfxml-20170921.tar.gz
	https://github.com/simsong/${PN}/archive/${P/_/}.tar.gz
"

LICENSE="GPL-3"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
SLOT="0"
IUSE="cairo test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	dev-db/sqlite
	dev-libs/boost:=
	dev-libs/openssl:=
	net-libs/http-parser:=
	net-libs/libpcap
	sys-libs/libcap-ng
	sys-libs/zlib:=
	cairo? (
		x11-libs/cairo
	)
"
DEPEND="
	${RDEPEND}
	test? ( sys-apps/coreutils )
"
S=${WORKDIR}/${PN}-${P/_/}
PATCHES=(
	"${FILESDIR}"/${PN}-1.5.0_alpha-libcapng.patch
	"${FILESDIR}"/${PN}-1.5.2-gentoo.patch
)

src_prepare() {
	mv "${WORKDIR}"/simsong-dfxml-7d11eaa/* src/dfxml/ || die
	mv "${WORKDIR}"/simsong-be13_api-c81521d/* src/be13_api/ || die

	default

	eautoreconf
}

src_configure() {
	append-cxxflags -fpermissive
	econf $(usex cairo --enable-cairo=true --enable-cairo=false)
}
