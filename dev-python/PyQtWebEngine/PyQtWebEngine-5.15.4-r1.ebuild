# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit python-r1 qmake-utils

DESCRIPTION="Python bindings for QtWebEngine"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqtwebengine/ https://pypi.org/project/PyQtWebEngine/"

MY_P=${PN}-${PV/_pre/.dev}
if [[ ${PV} == *_pre* ]]; then
	SRC_URI="https://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.gz"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
fi
S=${WORKDIR}/${MY_P}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="debug"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

# Minimal supported version of Qt.
QT_PV="5.15:5"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/PyQt5-5.15.4-r2[gui,network,printsupport,webchannel,widgets,${PYTHON_USEDEP}]
	>=dev-python/PyQt5-sip-4.19.22:=[${PYTHON_USEDEP}]
	dev-qt/qtcore:5
	dev-qt/qtwebengine:5[widgets]
"
BDEPEND="
	>=dev-python/PyQt-builder-1.10[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/sip-6.1[${PYTHON_USEDEP}]' python3_{8,9} )
	$(python_gen_cond_dep '>=dev-python/sip-6.2.0_pre0[${PYTHON_USEDEP}]' python3_10 )
	>=dev-qt/qtcore-${QT_PV}
"

src_configure() {
	configuration() {
		local myconf=(
			sip-build
			--qmake="$(qt5_get_bindir)"/qmake
			--build-dir="${BUILD_DIR}"
			--api-dir="${EPREFIX}"/usr/share/qt5/qsci/api/python/
			--scripts-dir="$(python_get_scriptdir)"
			$(usev debug '--debug --qml-debug --tracing')
			--verbose
			--no-make
		)
		echo "${myconf[@]}"
		"${myconf[@]}" || die
		
		run_in_build_dir eqmake5 -recursive ${PN}.pro
	}
	python_foreach_impl configuration
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	installation() {
		emake INSTALL_ROOT="${D}" install
		python_optimize
	}
	python_foreach_impl run_in_build_dir installation

	einstalldocs
}
