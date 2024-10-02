# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# Use ../hercules-sdl/files/gen_hashes.sh to identify the relevant
# commit when tagging new versions.
COMMIT="3aa2f4531b5fcbd0478ecbaf72ccc47079c67280"

DESCRIPTION="ANSI C General Decimal Arithmetic Library"
HOMEPAGE="https://github.com/SDL-Hercules-390/decNumber"
SRC_URI="https://github.com/SDL-Hercules-390/decNumber/archive/${COMMIT}.tar.gz -> decNumber-${COMMIT}.tar.gz"

S="${WORKDIR}/decNumber-${COMMIT}"
LICENSE="icu"
SLOT="0"
KEYWORDS="amd64 ppc64"
PATCHES=( "${FILESDIR}/cmakefix.patch" )
