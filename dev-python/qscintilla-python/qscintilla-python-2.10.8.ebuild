# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )
inherit python-r1 qmake-utils

MY_P=QScintilla_gpl-${PV/_pre/.dev}

DESCRIPTION="Python bindings for QScintilla"
HOMEPAGE="https://www.riverbankcomputing.com/software/qscintilla/intro"
SRC_URI="mirror://sourceforge/pyqt/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE="debug"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	>=dev-python/sip-4.19:=[${PYTHON_USEDEP}]
	dev-python/PyQt5[gui,printsupport,widgets,${PYTHON_USEDEP}]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	~x11-libs/qscintilla-${PV}:=
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}/Python

src_prepare() {
	default
	python_copy_sources
}

src_configure() {
	configuration() {
		local myconf=(
			"${PYTHON}"
			configure.py
			--pyqt=PyQt5
			--qmake="$(qt5_get_bindir)"/qmake
			--sip-incdir="$(python_get_includedir)"
			$(usex debug '--debug --trace' '')
			--verbose
			--no-dist-info # causes parallel build failures, reported upstream
		)
		echo "${myconf[@]}"
		"${myconf[@]}" || die

		# Run eqmake to respect toolchain, build flags, and prevent stripping
		eqmake5 -recursive
	}
	python_foreach_impl run_in_build_dir configuration
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
