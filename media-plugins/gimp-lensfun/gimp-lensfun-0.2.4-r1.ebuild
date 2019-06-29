# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Gimp plugin to correct lens distortions"
HOMEPAGE="https://seebk.github.io/GIMP-Lensfun/"
SRC_URI="https://github.com/seebk/GIMP-Lensfun/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openmp"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	media-gfx/exiv2
	<media-gfx/gimp-2.10.0
	>=media-libs/lensfun-0.3.2
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-exiv2-0.27.1.patch" )

S=${WORKDIR}/GIMP-Lensfun-${PV}

pkg_setup() {
	if use openmp && [[ ${MERGE_TYPE} != binary ]]; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare() {
	default

	if ! use openmp; then
		sed -i "s/-fopenmp//g" Makefile || die
	fi

	tc-export CXX
}

src_install() {
	exeinto $(gimptool-2.0 --gimpplugindir)/plug-ins
	doexe ${PN}
}
