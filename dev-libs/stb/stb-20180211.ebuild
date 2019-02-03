# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# There are no offical releases
CHECKSUM="e6afb9cbae4064da8c3e69af3ff5c4629579c1d2"

DESCRIPTION="single-file public domain (or MIT licensed) libraries for C/C++"
HOMEPAGE="https://github.com/nothings/stb"
SRC_URI="https://github.com/nothings/stb/archive/${CHECKSUM}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( MIT Unlicense )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

S="${WORKDIR}/${PN}-${CHECKSUM}"

DEPEND=""
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
