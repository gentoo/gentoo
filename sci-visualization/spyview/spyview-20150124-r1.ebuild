# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic

DESCRIPTION="2D and 3D data visualization and analysis program"
HOMEPAGE="http://nsweb.tn.tudelft.nl/~gsteele/spyview/"
SRC_URI="https://github.com/gsteele13/spyview/archive/966012afae2fbb77262bd96a7e530e81b0ed3b90.tar.gz -> $P.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	>=dev-libs/boost-1.62.0:=
	media-libs/netpbm
	x11-libs/fltk:1[opengl]
	app-text/ghostscript-gpl
	virtual/glu
"

DEPEND="${COMMON_DEPEND}
	sys-apps/groff"

RDEPEND="${COMMON_DEPEND}
	sci-visualization/gnuplot"

PATCHES=(
	"${FILESDIR}/${P}"-gnuplot_interface_fix.patch
	"${FILESDIR}/${P}"-gcc6cxx14-9.patch
)

src_unpack() {
	default
	mv -v "${WORKDIR}"/spyview-*/source "${S}" || die
}

src_prepare() {
	append-cflags $(fltk-config --cflags)
	append-cxxflags $(fltk-config --cxxflags)

	append-cxxflags -std=c++14

	append-cppflags -I"${EPREFIX}"/usr/include/netpbm

	# append-ldflags $(fltk-config --ldflags)
	# this one leads to an insane amount of warnings
	append-ldflags -L$(dirname $(fltk-config --libs))

	while IFS="" read -d $'\0' -r file; do
		sed -i -e 's:-mwindows -mconsole::g' "$file" || die
	done < <(find "${S}" -name Makefile.am -print0)

	default
	eautoreconf
}
