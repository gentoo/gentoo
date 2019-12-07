# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit scons-utils toolchain-funcs

DESCRIPTION="Peer-to-peer VPN software that abstracts a LAN over the Internet"
HOMEPAGE="http://www.freelan.org/"
SRC_URI="https://github.com/freelan-developers/freelan/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND="
	dev-libs/boost:=[threads]
	dev-libs/openssl:0=
	net-misc/curl:=
	virtual/libiconv
	net-libs/miniupnpc:=
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2-boost-1.70.patch
	"${FILESDIR}"/${PN}-2.2-boost-1.70-asio.patch
)

src_prepare() {
	export FREELAN_NO_GIT=1
	export FREELAN_NO_GIT_VERSION=${PV}

	sed -e "s/CXXFLAGS='-O3'/CXXFLAGS=''/" \
		-e "s/CXXFLAGS=\['-Werror'\]/CXXFLAGS=[]/" \
		-e "s/CXXFLAGS=\['-pedantic'\]/CXXFLAGS=[]/" \
		-i SConstruct || die
	default
}

src_compile() {
	tc-export CXX CC AR
	export LINK="$(tc-getCXX)"

	local MYSCONS=(
		"--mode=$(usex debug debug release)"
		prefix="${EPREFIX:-/}"
		bin_prefix="/usr"
		apps
	)
	escons "${MYSCONS[@]}"
}

src_install() {
	DESTDIR="${D}" escons --mode=release install prefix="${EPREFIX:-/}" bin_prefix="/usr"
	dobin build/release/bin/freelan
	dodoc CONTRIBUTING.md README.md

	newinitd "${FILESDIR}/openrc/freelan.initd" freelan
}
