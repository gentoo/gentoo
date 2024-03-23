# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit multibuild qmake-utils python-single-r1

DESCRIPTION="Asynchronous Python 3 Bindings for Qt"
HOMEPAGE="https://github.com/thp/pyotherside https://thp.io/2011/pyotherside/"
SRC_URI="https://github.com/thp/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv"
IUSE="qt5 qt6"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	|| ( qt5 qt6 )"

RDEPEND="
	${PYTHON_DEPS}
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdeclarative:5
		dev-qt/qtgui:5
		dev-qt/qtopengl:5
		dev-qt/qtsvg:5
	)
	qt6? (
		dev-qt/qtbase:6[opengl]
		dev-qt/qtdeclarative:6[opengl]
		dev-qt/qtquick3d:6[opengl]
		dev-qt/qtsvg:6
	)"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.0-qt6.5.patch
)

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt5) $(usev qt6) )
	python_setup
}

src_prepare() {
	default
	sed -i -e "s/qtquicktests//" pyotherside.pro || die
	multibuild_copy_sources
}

src_configure() {
	myconfigure() {
		pushd "${BUILD_DIR}" > /dev/null || die

		if [[ "${MULTIBUILD_VARIANT}" == qt5 ]]; then
			eqmake5
		elif [[ "${MULTIBUILD_VARIANT}" == qt6 ]]; then
			eqmake6
		else
			# This should never happen if REQUIRED_USE is enforced
			die "Neither Qt5 nor Qt6 support enabled, aborting"
		fi
		popd > /dev/null || die
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	mycompile() {
		pushd "${BUILD_DIR}" > /dev/null || die

		emake

		popd > /dev/null || die
	}

	multibuild_foreach_variant mycompile
}

src_test() {
	mytest() {
		pushd "${BUILD_DIR}" > /dev/null || die

		QT_QPA_PLATFORM="offscreen" tests/tests || die

		popd > /dev/null || die
	}

	multibuild_foreach_variant mytest
}

src_install() {
	myinstall() {
		pushd "${BUILD_DIR}" > /dev/null || die

		emake install INSTALL_ROOT="${D}"

		popd > /dev/null || die
	}

	multibuild_foreach_variant myinstall
}
