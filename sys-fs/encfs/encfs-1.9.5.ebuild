# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit cmake-utils

DESCRIPTION="An implementation of encrypted filesystem in user-space using FUSE"
HOMEPAGE="https://vgough.github.io/encfs/"
SRC_URI="https://github.com/vgough/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="amd64 arm ~ppc64 ~sparc x86"
IUSE="nls"

RDEPEND="
	dev-libs/openssl:0=
	dev-libs/tinyxml2:0=
	sys-fs/fuse:=
	sys-libs/zlib"
DEPEND="
	${RDEPEND}
	dev-lang/perl
	sys-devel/gettext
	virtual/pkgconfig"

# Build dir is hardcoded in test suite, but we restrict them
# because they can lead to false negatives, bug #630486
RESTRICT="test"
BUILD_DIR="${S}/build"

src_configure() {
	local mycmakeargs=(
		-DENABLE_NLS="$(usex nls)"
		-DUSE_INTERNAL_TINYXML=OFF
		-DBUILD_UNIT_TESTS=OFF
	)
	cmake-utils_src_configure
}
