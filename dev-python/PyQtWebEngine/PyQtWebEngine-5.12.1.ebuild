# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
inherit python-r1 qmake-utils

DESCRIPTION="Python bindings for Qt WebEngine framework"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqtwebengine/intro"

MY_P=${PN}_gpl-${PV/_pre/.dev}
SRC_URI="https://www.riverbankcomputing.com/static/Downloads/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="${PYTHON_DEPS}
	>=dev-python/PyQt5-5.12.1[${PYTHON_USEDEP},widgets]
	>=dev-python/PyQt5-sip-4.19.14:=[${PYTHON_USEDEP}]
	>=dev-qt/qtwebengine-5.12[widgets]"
DEPEND="${RDEPEND}
	>=dev-python/sip-4.19.14[${PYTHON_USEDEP}]"
BDEPEND=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	python_copy_sources
}

src_configure() {
	configuration() {
		local myconf=(
			"${PYTHON}"
			"${S}"/configure.py
			$(usex debug '--debug --trace' '')
			--destdir="$(python_get_sitedir)"/PyQt5
			--qmake="$(qt5_get_bindir)"/qmake
			--sip-incdir="$(python_get_includedir)"
			--verbose
		)
		echo "${myconf[@]}"
		"${myconf[@]}" || die

		eqmake5 -recursive ${PN}.pro
	}
	python_foreach_impl run_in_build_dir configuration
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	installation() {
		# Parallel install fails
		emake -j1 INSTALL_ROOT="${D}" install
		python_optimize
	}
	python_foreach_impl run_in_build_dir installation
	einstalldocs
}
