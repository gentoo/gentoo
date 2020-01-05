# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )
inherit python-r1 qmake-utils

DESCRIPTION="Python bindings for QScintilla"
HOMEPAGE="https://www.riverbankcomputing.com/software/qscintilla/intro"

MY_PN=QScintilla
MY_P=${MY_PN}-${PV/_pre/.dev}
if [[ ${PV} == *_pre* ]]; then
	SRC_URI="https://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.gz"
else
	SRC_URI="https://www.riverbankcomputing.com/static/Downloads/${MY_PN}/${PV}/${MY_P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE="debug"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/PyQt5-5.12[gui,printsupport,widgets,${PYTHON_USEDEP}]
	>=dev-python/PyQt5-sip-4.19.14:=[${PYTHON_USEDEP}]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	~x11-libs/qscintilla-${PV}:=
"
DEPEND="${RDEPEND}
	>=dev-python/sip-4.19.14[${PYTHON_USEDEP}]
"

S=${WORKDIR}/${MY_P}/Python

src_configure() {
	configuration() {
		local myconf=(
			"${PYTHON}"
			"${S}"/configure.py
			--pyqt=PyQt5
			--qmake="$(qt5_get_bindir)"/qmake
			$(usex debug '--debug --trace' '')
			--verbose
		)
		echo "${myconf[@]}"
		"${myconf[@]}" || die

		# Fix parallel install failure
		sed -i -e '/INSTALLS += distinfo/i distinfo.depends = install_subtargets install_pep484_stubs install_api' \
			${MY_PN}.pro || die

		# Run eqmake to respect toolchain and build flags
		eqmake5 -recursive ${MY_PN}.pro
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
