# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic qmake-utils toolchain-funcs

DESCRIPTION="Visualisation and processing of experimental and simulated NMR spectra"
HOMEPAGE="https://sourceforge.net/projects/gsim/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_sse3 emf opengl"
REQUIRED_USE="cpu_flags_x86_sse3"

RDEPEND="
	dev-cpp/muParser
	media-libs/freetype
	sci-libs/libcmatrix
	sci-libs/minuit
	virtual/blas
	dev-qt/qtsvg:4
	emf? ( media-libs/libemf )
	opengl? ( dev-qt/qtopengl:4 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-build.conf.patch"
)
DOCS="release.txt README_GSIM.* quickstart.* changes.log programming.*"

src_prepare() {
	edos2unix ${PN}.pro

	default

	# C{,XX}FLAGS need to explicitly enable SSE3 support
	# bug #555972
	filter-flags -mno-sse3
	append-cflags -msse3
	append-cxxflags -msse3

	cat >> build.conf <<- EOF
	INCLUDEPATH += "${EPREFIX}/usr/include/libcmatrixR3/" \
		"${EPREFIX}/usr/include/Minuit2" \
		"${EPREFIX}/usr/include"
	LIBS += -lcmatrix  -lMinuit2 -lmuparser $($(tc-getPKG_CONFIG) --libs cblas)
	EOF

	use opengl && echo "CONFIG+=use_opengl" >> build.conf

	if use emf; then
		cat >> build.conf <<- EOF
		CONFIG+=use_emf
		DEFINES+=USE_EMF_OUTPUT
		LIBS += -L\"${EPREFIX}/usr/include/libEMF\" -lEMF
		EOF
	fi
	sed \
		-e "s:quickstart.pdf:../share/doc/${PF}/quickstart.pdf:g" \
		-e "s:README_GSIM.pdf:../share/doc/${PF}/README_GSIM.pdf:g" \
		-i mainform.h || die
}

src_configure() {
	eqmake4 ${PN}.pro
}

src_install() {
	default
	dobin ${PN}
	insinto /usr/share/${PN}
	doins -r images ${PN}.ico
	insinto /usr/share/${PN}/ui
	doins *.ui
}
