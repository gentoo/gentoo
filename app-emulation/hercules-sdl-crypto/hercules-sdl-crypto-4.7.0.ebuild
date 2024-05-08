# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# Use ../hercules-sdl/files/gen_hashes.sh to identify the relevant
# commit when tagging new versions.
COMMIT="a5096e5dd79f46b568806240c0824cd8cb2fcda2"

DESCRIPTION="Simple AES/DES encryption and SHA1/SHA2 hashing library"
HOMEPAGE="https://github.com/SDL-Hercules-390/crypto"
SRC_URI="https://github.com/SDL-Hercules-390/crypto/archive/${COMMIT}.tar.gz -> crypto-${COMMIT}.tar.gz"

S="${WORKDIR}/crypto-${COMMIT}"
LICENSE="public-domain MIT BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
PATCHES=( "${FILESDIR}/cmakefix.patch" )
