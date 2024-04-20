# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DIR="doc"
DOCS_CONFIG_NAME="Doxyfile"
DOCS_DEPEND="
	media-gfx/graphviz
	virtual/latex-base
"

inherit docs cmake

COMMIT="f7519200f102676fb04fb7bd0be555e0a419d378"

DESCRIPTION="2D plotting library for Qt5"
HOMEPAGE="https://qwt.sourceforge.io/ https://github.com/SciDAVis/qwt5-qt5"
SRC_URI="https://github.com/SciDAVis/qwt5-qt5/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}5-qt5-${COMMIT}"

LICENSE="qwt"
KEYWORDS="amd64 ~arm ppc ppc64 ~riscv x86"
SLOT="5"
IUSE="designer examples"

DEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	dev-qt/qtsvg:5
	designer? ( dev-qt/designer:5 )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-install-headers.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=$(usex examples)
		-DQWT_DESIGNER=$(usex designer)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	docs_compile
}

src_install() {
	cmake_src_install

	# avoid file conflict with qwt:6
	# https://github.com/gbm19/qwt5-qt5/issues/2
	pushd "${ED}/usr/share/man/man3/" || die
		for f in *; do
			mv ${f} ${f//.3/.5qt5.3} || die
		done
	popd || die
}
