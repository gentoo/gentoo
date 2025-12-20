# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake dot-a

DESCRIPTION="SIMD Vector Class Library for C++"
HOMEPAGE="https://github.com/VcDevel/Vc"
SRC_URI="https://github.com/VcDevel/Vc/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/Vc-${PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~x86 ~x64-macos"

src_configure() {
	lto-guarantee-fat
	cmake_src_configure
}

src_install() {
	cmake_src_install
	strip-lto-bytecode
}
