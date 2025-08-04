# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake dot-a

# Use ../hercules-sdl/files/gen_hashes.sh to identify the relevant
# commit when tagging new versions.
COMMIT="9ac58405c2b91fb7cd230aed474dc7059f0fcad9"

DESCRIPTION="Simple AES/DES encryption and SHA1/SHA2 hashing library"
HOMEPAGE="https://github.com/SDL-Hercules-390/crypto"
SRC_URI="https://github.com/SDL-Hercules-390/crypto/archive/${COMMIT}.tar.gz -> ${PN}-${COMMIT}.tar.gz"

S="${WORKDIR}/crypto-${COMMIT}"
LICENSE="public-domain MIT BSD"
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
