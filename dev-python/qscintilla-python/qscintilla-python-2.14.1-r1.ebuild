# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit multibuild python-r1 qmake-utils

DESCRIPTION="Python bindings for QScintilla"
HOMEPAGE="https://www.riverbankcomputing.com/software/qscintilla/ https://pypi.org/project/QScintilla/"

MY_PN=QScintilla
MY_P=${MY_PN}_src-${PV/_pre/.dev}
if [[ ${PV} == *_pre* ]]; then
	SRC_URI="https://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.gz"
else
	SRC_URI="https://www.riverbankcomputing.com/static/Downloads/${MY_PN}/${PV}/${MY_P}.tar.gz"
fi
S=${WORKDIR}/${MY_P}/Python

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 x86"
IUSE="debug +qt5 qt6"

REQUIRED_USE="|| ( qt5 qt6 ) ${PYTHON_REQUIRED_USE}"

# no tests
RESTRICT="test"

DEPEND="${PYTHON_DEPS}
	qt5? (
		>=dev-python/PyQt5-5.15.5[gui,printsupport,widgets,${PYTHON_USEDEP}]
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
	)
	qt6? (
		dev-python/PyQt6[gui,printsupport,widgets,${PYTHON_USEDEP}]
		dev-qt/qtbase:6[cups,gui,widgets]
	)
	~x11-libs/qscintilla-${PV}:=[qt5=,qt6=]
"
RDEPEND="${DEPEND}
	qt5? ( >=dev-python/PyQt5-sip-12.9:=[${PYTHON_USEDEP}] )
	qt6? ( >=dev-python/PyQt6-sip-13.5:=[${PYTHON_USEDEP}] )
"
BDEPEND="
	>=dev-python/PyQt-builder-1.10[${PYTHON_USEDEP}]
	>=dev-python/sip-6.2[${PYTHON_USEDEP}]
	qt5? ( dev-qt/qtcore:5 )
	qt6? ( dev-qt/qtbase:6 )
"

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt5) $(usev qt6) )
}

src_configure() {
	my_src_configure() {
		case ${MULTIBUILD_VARIANT} in
			qt5) local QMAKE=qmake5 ;;
			qt6) local QMAKE=qmake6 ;;
		esac
		configuration() {
			local myconf=(
				sip-build
				--verbose
				--build-dir="${BUILD_DIR}"
				--scripts-dir="$(python_get_scriptdir)"
				--qmake="/usr/bin/${QMAKE}"
				--no-make
				$(usev debug '--debug --qml-debug --tracing')
			)
			echo "${myconf[@]}"
			"${myconf[@]}" || die

			# Run eqmake to respect toolchain and build flags
			run_in_build_dir "${QMAKE}" -recursive ${MY_PN}.pro
		}
		mv pyproject{-${MULTIBUILD_VARIANT},}.toml || die
		python_foreach_impl configuration
	}
	multibuild_foreach_variant my_src_configure
}

src_compile() {
	multibuild_foreach_variant python_foreach_impl run_in_build_dir default
}

src_install() {
	installation() {
		emake INSTALL_ROOT="${D}" install
		python_optimize
	}
	multibuild_foreach_variant python_foreach_impl run_in_build_dir installation
}
