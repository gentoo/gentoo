# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A reference implementation of the Russian GOST crypto algorithms for OpenSSL"
HOMEPAGE="https://github.com/gost-engine/engine"
IUSE="test"
RESTRICT="!test? ( test )"
SLOT="0/${PV}"

COMMON_DEPEND=">=dev-libs/openssl-3.0.0:0="
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	test? (
		dev-lang/perl
	)"
RDEPEND="${COMMON_DEPEND}"

LICENSE="openssl"

DOCS=( INSTALL.md README.gost README.md )

LIBPROV_COMMIT="8a126e09547630ef900177625626b6156052f0ee"
if [[ ${PV} == "9999" ]] ; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/gost-engine/engine.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~hppa"
	SRC_URI="https://github.com/gost-engine/engine/archive/v${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/provider-corner/libprov/archive/${LIBPROV_COMMIT}.tar.gz -> libprov-${LIBPROV_COMMIT}.tar.gz"
	S="${WORKDIR}/engine-${PV}"
fi

src_prepare() {
	cp -R "${WORKDIR}/libprov-${LIBPROV_COMMIT}/." "${S}/libprov" || die
	cmake_src_prepare
	sed 's:Werror:Wno-error:g' -i "${S}/CMakeLists.txt" || die
}
