# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# Use ../hercules-sdl/files/gen_hashes.sh to identify the relevant
# commit when tagging new versions.
COMMIT="729f0b688c1426018112c1e509f207fb5f266efa"

DESCRIPTION="Simple RFC-complient TELNET implementation"
HOMEPAGE="https://github.com/SDL-Hercules-390/telnet"
SRC_URI="https://github.com/SDL-Hercules-390/telnet/archive/${COMMIT}.tar.gz -> telnet-${COMMIT}.tar.gz"

S="${WORKDIR}/telnet-${COMMIT}"
LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc64"
PATCHES=( "${FILESDIR}/cmakefix.patch" )
