# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools qmake-utils

DESCRIPTION="Library and GUI software for NanoVNA V2"
HOMEPAGE="https://github.com/nanovna-v2/NanoVNA-QT"
SRC_URI="https://github.com/nanovna-v2/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-cpp/eigen:3=
	dev-qt/qtcharts:5=
	dev-qt/qtcore:5=
	dev-qt/qtgui:5=
	dev-qt/qtsvg:5=
	dev-qt/qtwidgets:5=
	sci-libs/fftw:3.0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-20200507-missing_headers.patch
)

DOCS=( README.md ug1101.pdf )

src_prepare() {
	default
	eautoreconf
	sed -i -e "s|/usr/lib|/usr/$(get_libdir)|" libxavna/xavna_mock_ui/xavna_mock_ui.pro || die
}

src_configure() {
	default

	pushd libxavna/xavna_mock_ui > /dev/null || die
	eqmake5
	popd > /dev/null || die

	pushd vna_qt > /dev/null || die
	eqmake5
	popd > /dev/null || die
}

src_compile() {
	default

	pushd libxavna/xavna_mock_ui > /dev/null || die
	emake
	popd > /dev/null || die

	pushd vna_qt > /dev/null || die
	emake
	popd > /dev/null || die
}

src_install() {
	default

	pushd libxavna/xavna_mock_ui > /dev/null || die
	emake INSTALL_ROOT="${D}" install
	popd > /dev/null || die

	pushd vna_qt > /dev/null || die
	dobin vna_qt
	popd > /dev/null || die

	find "${ED}" -name '*.la' -delete || die
}
