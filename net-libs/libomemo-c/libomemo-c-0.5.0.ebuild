# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="XMPP fork of Signal Protocol C Library supporting XEP-0384 OMEMO"
HOMEPAGE="https://github.com/dino/libomemo-c/"
SRC_URI="https://github.com/dino/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD BSD-1 GPL-3 ISC"
KEYWORDS="amd64"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/protobuf-c:="
DEPEND="${RDEPEND}
	test? (
		dev-libs/check
		dev-libs/openssl
	)
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
