# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit scons-utils toolchain-funcs eutils

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
"
RDEPEND="${DEPEND}"

FREELAN_NO_GIT=1
FREELAN_NO_GIT_VERSION=${PV}

src_prepare() {
	epatch \
		"${FILESDIR}/boost158.patch" \
		"${FILESDIR}/mf.patch" \
		"${FILESDIR}/prefix.patch"

	sed -e "s/CXXFLAGS='-O3'/CXXFLAGS=''/" \
		-e "s/CXXFLAGS=\['-Werror'\]/CXXFLAGS=[]/" \
		-e "s/CXXFLAGS=\['-pedantic'\]/CXXFLAGS=[]/" \
		-i SConstruct || die
	epatch_user
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
	DESTDIR="${D}" escons --mode=release prefix="${EPREFIX:-/}" bin_prefix="/usr" install
	dodoc CONTRIBUTING.md README.md

	newinitd "${FILESDIR}/openrc/freelan.initd" freelan
}
