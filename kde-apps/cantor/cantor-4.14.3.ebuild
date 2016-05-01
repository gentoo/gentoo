# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
PYTHON_COMPAT=( python2_7 )
inherit kde4-base python-single-r1

DESCRIPTION="KDE4 interface for doing mathematics and scientific computing"
HOMEPAGE="https://www.kde.org/applications/education/cantor https://edu.kde.org/cantor"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="analitza debug postscript python qalculate +R"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# TODO Add Sage Mathematics Software backend (http://www.sagemath.org)
RDEPEND="
	analitza? ( $(add_kdeapps_dep analitza) )
	qalculate? (
		sci-libs/cln
		sci-libs/libqalculate
	)
	postscript? ( app-text/libspectre )
	python? ( ${PYTHON_DEPS} )
	R? ( dev-lang/R )
	dev-qt/qtxmlpatterns:4
"
DEPEND="${RDEPEND}
	>=dev-cpp/eigen-2.0.3:2
"

RESTRICT="test"

pkg_setup() {
	use python && python-single-r1_pkg_setup
	kde4-base_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with analitza)
		$(cmake-utils_use_with postscript LibSpectre)
		$(cmake-utils_use_with python PythonLibs)
		$(cmake-utils_use_with qalculate)
		$(cmake-utils_use_with R)
	)
	kde4-base_src_configure
}

pkg_postinst() {
	kde4-base_pkg_postinst

	if ! use analitza && ! use python && ! use qalculate && ! use R; then
		echo
		ewarn "You have decided to build ${PN} with no backend."
		ewarn "To have this application functional, please do one of below:"
		ewarn "    # emerge -va1 '='${CATEGORY}/${P} with 'analitza', 'python', 'qalculate' or 'R' USE flag enabled"
		ewarn "    # emerge -vaDu sci-mathematics/maxima"
		echo
	fi
}
