# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="2D and 3D data visualization and analysis program"
HOMEPAGE="https://github.com/gsteele13/spyview"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gsteele13/spyview.git"
else
	SRC_URI="https://github.com/gsteele13/spyview/archive/966012afae2fbb77262bd96a7e530e81b0ed3b90.tar.gz -> $P.tgz
		https://dev.gentoo.org/~mgorny/dist/${P}-patchset.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
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
	"${WORKDIR}/${P}-patchset/${P}"-gnuplot_interface_fix.patch
	"${WORKDIR}/${P}-patchset/${P}"-gcc6cxx14-9.patch
)

src_unpack() {
	if [[ ${PV} == *9999* ]] ; then
		git-r3_src_unpack
		S="${WORKDIR}/${P}/source"
	else
		default
		mv -v "${WORKDIR}"/spyview-*/source "${S}" || die
	fi
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

	if [[ ${PV} == *9999* ]] ; then
		eapply_user
	else
		default
	fi
	eautoreconf
}
