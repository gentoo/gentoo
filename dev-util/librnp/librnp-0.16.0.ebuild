# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="High performance C++ OpenPGP library"
HOMEPAGE="https://www.rnpgp.org/ https://github.com/rnpgp/rnp"
SRC_URI="https://github.com/rnpgp/rnp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="man"

DEPEND="app-arch/bzip2
	dev-libs/botan:2=
	dev-libs/json-c:=
	sys-libs/zlib"
RDEPEND="${DEPEND}"
BDEPEND="man? ( dev-ruby/asciidoctor )"

S="${WORKDIR}/${P/*lib/}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=off

		-DCRYPTO_BACKEND=botan

		-DDOWNLOAD_GTEST=off
		-DDOWNLOAD_RUBYRNP=off

		-DENABLE_COVERAGE=off
		-DENABLE_FUZZERS=off
		-DENABLE_SANITIZERS=off
	)

	if use man; then
		mycmakeargs+=( -DENABLE_DOC=on )
	else
		mycmakeargs+=( -DENABLE_DOC=off )
	fi

	cmake_src_configure
}
