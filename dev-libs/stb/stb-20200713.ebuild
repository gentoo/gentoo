# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# There are no official releases
CHECKSUM="b42009b3b9d4ca35bc703f5310eedc74f584be58"

DESCRIPTION="single-file public domain (or MIT licensed) libraries for C/C++"
HOMEPAGE="https://github.com/nothings/stb"
SRC_URI="https://github.com/nothings/stb/archive/${CHECKSUM}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( MIT Unlicense )"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

IUSE=""

S="${WORKDIR}/${PN}-${CHECKSUM}"

BDEPEND=""
RDEPEND=""

src_prepare() {
	default

	# Move the header files in a folder so they don't pollute the include dir
	mkdir stb || die
	mv *.h stb/ || die
}

src_install() {
	doheader -r stb
}
