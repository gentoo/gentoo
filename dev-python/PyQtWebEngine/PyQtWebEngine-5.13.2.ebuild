# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7,8} )
inherit python-r1 qmake-utils

DESCRIPTION="Python bindings for QtWebEngine"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqtwebengine/intro"

MY_P=${PN}-${PV/_pre/.dev}
if [[ ${PV} == *_pre* ]]; then
	SRC_URI="https://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.gz"
else
	SRC_URI="https://www.riverbankcomputing.com/static/Downloads/${PN}/${PV}/${MY_P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 x86"
IUSE="debug"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/PyQt5-5.13.1[gui,network,printsupport,ssl,webchannel,widgets,${PYTHON_USEDEP}]
	>=dev-python/PyQt5-sip-4.19.14:=[${PYTHON_USEDEP}]
	dev-qt/qtcore:5
	dev-qt/qtwebengine:5[widgets]
"
DEPEND="${RDEPEND}
	>=dev-python/sip-4.19.14[${PYTHON_USEDEP}]
"

S=${WORKDIR}/${MY_P}

src_configure() {
	configuration() {
		local myconf=(
			"${PYTHON}"
			"${S}"/configure.py
			--qmake="$(qt5_get_bindir)"/qmake
			$(usex debug '--debug --trace' '')
			--verbose
		)
		echo "${myconf[@]}"
		"${myconf[@]}" || die

		# Fix parallel install failure
		sed -i -e '/INSTALLS += distinfo/i distinfo.depends = install_subtargets install_pep484_stubs install_api' \
			${PN}.pro || die

		# Run eqmake to respect toolchain and build flags
		eqmake5 -recursive ${PN}.pro
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

	einstalldocs
}
