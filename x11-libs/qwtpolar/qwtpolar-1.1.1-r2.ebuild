# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Library for displaying values on a polar coordinate system"
HOMEPAGE="https://qwtpolar.sourceforge.io/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="qwt"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	x11-libs/qwt:6=[designer,qt5(+),svg]
"
DEPEND="${RDEPEND}
	dev-qt/qtconcurrent:5
"

src_prepare() {
	default

	local qtplugindir="${EPREFIX}$(qt5_get_plugindir)"

	sed \
		-e "/QWT_POLAR_INSTALL_PREFIX /s:=.*$:= ${EPREFIX}/usr:g" \
		-e "/QWT_POLAR_INSTALL_LIBS/s:lib:$(get_libdir):g" \
		-e "/QWT_POLAR_INSTALL_DOCS/s:doc:share/doc/${PF}:g" \
		-e "/QWT_POLAR_INSTALL_PLUGINS/s:=.*$:= ${qtplugindir}/designer/:g" \
		-e "/QWT_POLAR_INSTALL_FEATURES/s:=.*$:= ${qtplugindir}/features/:g" \
		-e "/= QwtPolarDesigner/ d" \
		-e "/= QwtPolarExamples/d" \
		-i ${PN}config.pri || die

	sed \
		-e "s:{QWT_POLAR_ROOT}/lib:{QWT_POLAR_ROOT}/$(get_libdir):" \
		-i src/src.pro || die
	echo "INCLUDEPATH += ${EPREFIX}/usr/include/qwt6" >> src/src.pro
	cat >> designer/designer.pro <<- EOF
	INCLUDEPATH += "${EPREFIX}"/usr/include/qwt6
	LIBS += -L"${S}/$(get_libdir)"
	EOF
}

src_configure() {
	eqmake5
}

src_install() {
	emake DESTDIR="${D}" INSTALL_ROOT="${D}" install
	einstalldocs
}
