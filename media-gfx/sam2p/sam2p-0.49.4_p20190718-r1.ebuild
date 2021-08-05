# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

COMMIT="b953f63307c4a83fa4615a4863e3fb250205cd98"

DESCRIPTION="Utility to convert raster images to EPS, PDF and many others"
HOMEPAGE="https://github.com/pts/sam2p"
SRC_URI="https://github.com/pts/sam2p/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
IUSE="examples gif"
RESTRICT="test"

BDEPEND="dev-lang/perl"

S="${WORKDIR}/${PN}-${COMMIT}"

PATCHES=( "${FILESDIR}"/${PN}-build-fixes.patch )

src_prepare() {
	default

	# configure.in files are deprecated
	mv configure.{in,ac} || die

	# missing include for memset
	sed -i '1s;^;#include <string.h>\n;' pts_defl.c

	# eautoreconf is still needed or you get bad warnings
	eautoreconf
}

src_configure() {
	tc-export CC CXX

	econf \
		--enable-lzw \
		$(use_enable gif)
}

src_compile() {
	emake GCC_STRIP=
}

src_install() {
	dobin sam2p
	einstalldocs

	if use examples; then
		# clear pre-compressed files
		rm examples/*.gz || die

		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
