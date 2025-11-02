# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake dot-a

# Use ../hercules-sdl/files/gen_hashes.sh to identify the relevant
# commit when tagging new versions.
COMMIT="995184583107625015bb450228a5f3fb781d9502"

DESCRIPTION="ANSI C General Decimal Arithmetic Library"
HOMEPAGE="https://github.com/SDL-Hercules-390/decNumber"
SRC_URI="https://github.com/SDL-Hercules-390/decNumber/archive/${COMMIT}.tar.gz -> ${PN}-${COMMIT}.tar.gz"

S="${WORKDIR}/decNumber-${COMMIT}"
LICENSE="icu"
SLOT="0"
KEYWORDS="amd64 ppc64"
PATCHES=( "${FILESDIR}/cmakefix.patch" )

src_configure() {
	lto-guarantee-fat
	cmake_src_configure
}

src_install() {
	cmake_src_install
	strip-lto-bytecode
}
