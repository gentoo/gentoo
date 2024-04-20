# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# There are no official releases
CHECKSUM="f4a71b13373436a2866c5d68f8f80ac6f0bc1ffe"

DESCRIPTION="single-file public domain (or MIT licensed) libraries for C/C++"
HOMEPAGE="https://github.com/nothings/stb"
SRC_URI="https://github.com/nothings/stb/archive/${CHECKSUM}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${CHECKSUM}"

LICENSE="|| ( MIT Unlicense )"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

src_prepare() {
	default

	# Move the header files in a folder so they don't pollute the include dir
	mkdir stb || die
	mv *.h stb/ || die
	mv deprecated stb/ || die
}

src_install() {
	doheader -r stb

	insinto /usr/share/pkgconfig
	cat > "${D}"/usr/share/pkgconfig/stb.pc <<-EOF
	prefix=/usr
	includedir=\${prefix}/include/stb

	Name: stb
	Description: stb single-file public domain libraries
	Version: ${PV}
	Cflags: -I\${includedir}
	EOF
}
