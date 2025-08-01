# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake dot-a

# Use ../hercules-sdl/files/gen_hashes.sh to identify the relevant
# commit when tagging new versions.
COMMIT="384b2542dfc9af67ca078e2bc13487a8fc234a3f"

DESCRIPTION="Simple RFC-complient TELNET implementation"
HOMEPAGE="https://github.com/SDL-Hercules-390/telnet"
SRC_URI="https://github.com/SDL-Hercules-390/telnet/archive/${COMMIT}.tar.gz -> ${PN}-${COMMIT}.tar.gz"

S="${WORKDIR}/telnet-${COMMIT}"
LICENSE="public-domain"
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
