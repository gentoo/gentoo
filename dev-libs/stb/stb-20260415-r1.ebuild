# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

# There are no official releases
CHECKSUM="31c1ad37456438565541f4919958214b6e762fb4"

DESCRIPTION="Single-file C/C++ libraries for various purposes"
HOMEPAGE="https://github.com/nothings/stb"
SRC_URI="https://github.com/nothings/stb/archive/${CHECKSUM}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${CHECKSUM}"

LICENSE="|| ( MIT Unlicense )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

src_prepare() {
	default

	# Move the header files in a folder so they don't pollute the include dir
	mkdir stb || die
	mv *.c *.h stb/ || die
	mv deprecated stb/ || die
}

src_install() {
	doheader -r stb

	insinto /usr/share/pkgconfig
	newins - stb.pc <<-EOF
	prefix="${EPREFIX}/usr"
	includedir=\${prefix}/include/stb

	Name: stb
	Description: ${DESCRIPTION}
	Version: ${PV}
	Cflags: -I\${includedir}
	EOF
}
