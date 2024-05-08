# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# Use ../hercules-sdl/files/gen_hashes.sh to identify the relevant
# commit when tagging new versions.
COMMIT="4b0c326008e174610969c92e69178939ed80653d"

DESCRIPTION="Berkeley IEEE Binary Floating-Point Library"
HOMEPAGE="https://github.com/SDL-Hercules-390/SoftFloat"
SRC_URI="https://github.com/SDL-Hercules-390/SoftFloat/archive/${COMMIT}.tar.gz -> SoftFloat-${COMMIT}.tar.gz"

S="${WORKDIR}/SoftFloat-${COMMIT}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
PATCHES=( "${FILESDIR}/cmakefix.patch" )
