# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )
inherit pypi python-r1 qmake-utils

DESCRIPTION="Python bindings for QtWebEngine"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqtwebengine/ https://pypi.org/project/PyQtWebEngine/"

if [[ ${PV} == *_pre* ]]; then
	MY_P=${PN}-${PV/_pre/.dev}
	SRC_URI="https://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.gz"
	S=${WORKDIR}/${MY_P}
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~x86"
IUSE="debug"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

DEPEND="${PYTHON_DEPS}
	>=dev-python/PyQt5-5.15.5[gui,network,printsupport,ssl,webchannel,widgets,${PYTHON_USEDEP}]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwebengine:5[widgets]
"
RDEPEND="${DEPEND}
	>=dev-python/PyQt5-sip-12.9:=[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/PyQt-builder-1.10[${PYTHON_USEDEP}]
	>=dev-python/sip-6.2[${PYTHON_USEDEP}]
	dev-qt/qtcore:5
"

src_configure() {
	configuration() {
		local myconf=(
			sip-build
			--verbose
			--build-dir="${BUILD_DIR}"
			--scripts-dir="$(python_get_scriptdir)"
			--qmake="$(qt5_get_bindir)"/qmake
			--no-make
			$(usev debug '--debug --qml-debug --tracing')
		)
		echo "${myconf[@]}"
		"${myconf[@]}" || die

		# Run eqmake to respect toolchain and build flags
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
