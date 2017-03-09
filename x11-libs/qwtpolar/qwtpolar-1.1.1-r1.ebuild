# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="Library for displaying values on a polar coordinate system"
HOMEPAGE="http://qwtpolar.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="qwt"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+qt4 qt5"

REQUIRED_USE="^^ ( qt4 qt5 )"

RDEPEND="
	qt4? ( x11-libs/qwt:6=[designer,qt4(+),svg] )
	qt5? ( x11-libs/qwt:6=[designer,qt5,svg] )
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	local qtplugindir="${EPREFIX}$(qt4_get_plugindir)"
	use qt5 && qtplugindir="${EPREFIX}$(qt5_get_plugindir)"

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
	if use qt5; then
		eqmake5
	else
		eqmake4
	fi
}

src_install() {
	emake DESTDIR="${D}" INSTALL_ROOT="${D}" install
	einstalldocs
}
