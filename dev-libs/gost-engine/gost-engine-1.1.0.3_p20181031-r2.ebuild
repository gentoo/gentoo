# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A reference implementation of the Russian GOST crypto algorithms for OpenSSL"
HOMEPAGE="https://github.com/gost-engine/engine"
IUSE="test"
RESTRICT="!test? ( test )"
SLOT="0/${PV}"

COMMON_DEPEND=">=dev-libs/openssl-1.1.1:0="
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	test? (
		dev-lang/perl
	)"
RDEPEND="${COMMON_DEPEND}"

LICENSE="openssl"

DOCS=( INSTALL.md README.gost README.md )

if [[ ${PV} == "9999" ]] ; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/gost-engine/engine.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~hppa"
	SRC_URI="https://github.com/gost-engine/engine/archive/e5cc3684f3b3ad40e186e23b00b253d234df92ab.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/engine-e5cc3684f3b3ad40e186e23b00b253d234df92ab"
fi

src_prepare() {
	cmake_src_prepare
	sed 's:Werror:Wno-error:g' -i "${S}/CMakeLists.txt" || die
}
