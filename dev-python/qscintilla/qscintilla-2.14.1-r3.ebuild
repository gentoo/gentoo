# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit python-r1 qmake-utils out-of-source-utils

DESCRIPTION="Python bindings for QScintilla"
HOMEPAGE="https://www.riverbankcomputing.com/software/qscintilla/ https://pypi.org/project/QScintilla/"

MY_PN=QScintilla
MY_P=${MY_PN}_src-${PV/_pre/.dev}
SRC_URI="https://www.riverbankcomputing.com/static/Downloads/${MY_PN}/${PV}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}/Python

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE="debug"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# no tests
RESTRICT="test"

DEPEND="${PYTHON_DEPS}
	dev-python/pyqt6[gui,printsupport,widgets,${PYTHON_USEDEP}]
	dev-qt/qtbase:6[gui,widgets]
	~x11-libs/qscintilla-${PV}:=[qt6(+)]
"
RDEPEND="${DEPEND}
	!=x11-libs/qscintilla-2.14.1-r0
	>=dev-python/pyqt6-sip-13.5:=[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/pyqt-builder-1.10[${PYTHON_USEDEP}]
	>=dev-python/sip-6.2[${PYTHON_USEDEP}]
	dev-qt/qtbase:6
"

src_prepare() {
	default
	mv pyproject{-qt6,}.toml || die
}

src_configure() {
	configuration() {
		local myconf=(
			sip-build
			--verbose
			--build-dir="${BUILD_DIR}"
			--scripts-dir="$(python_get_scriptdir)"
			--qmake="$(qt6_get_bindir)"/qmake
			--no-make
			$(usev debug '--debug --qml-debug --tracing')
		)
		echo "${myconf[@]}"
		"${myconf[@]}" || die

		run_in_build_dir eqmake6 -recursive PyQt6-${MY_PN}.pro
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
}
