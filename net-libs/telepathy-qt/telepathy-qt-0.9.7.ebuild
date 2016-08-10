# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 cmake-utils virtualx multibuild

DESCRIPTION="Qt bindings for the Telepathy D-Bus protocol"
HOMEPAGE="https://telepathy.freedesktop.org/"
SRC_URI="https://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="debug farstream +qt4 qt5 test"

REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="
	farstream? (
		>=net-libs/telepathy-farstream-0.2.2
		>=net-libs/telepathy-glib-0.18.0
	)
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtxml:5
	)
	!net-libs/telepathy-qt4
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	test? (
		dev-libs/dbus-glib
		dev-libs/glib:2
		dev-python/dbus-python
		qt4? ( dev-qt/qttest:4 )
		qt5? ( dev-qt/qttest:5 )
	)
"

DOCS=( AUTHORS ChangeLog HACKING NEWS README )

PATCHES=(
	"${FILESDIR}/${PN}-0.9.6.1-yes-release.patch"
	"${FILESDIR}/${PN}-0.9.6.1-qtpath.patch"
)

# bug 549448 - last checked with 0.9.7
RESTRICT="test"

pkg_setup() {
	python-any-r1_pkg_setup

	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
}

src_configure() {
	myconfigure() {
		local mycmakeargs=(
			-DENABLE_DEBUG_OUTPUT=$(usex debug)
			-DENABLE_FARSTREAM=$(usex farstream)
			-DENABLE_TESTS=$(usex test)
			-DENABLE_EXAMPLES=OFF
		)
		if [[ ${MULTIBUILD_VARIANT} = qt4 ]]; then
			mycmakeargs+=( -DDESIRED_QT_VERSION=4 )
		fi
		if [[ ${MULTIBUILD_VARIANT} = qt5 ]]; then
			mycmakeargs+=( -DDESIRED_QT_VERSION=5 )
		fi
		cmake-utils_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile
}

src_test() {
	_test_runner() {
		ctest -E '(CallChannel)'
	}

	mytest() {
		pushd "${BUILD_DIR}" > /dev/null || die
		virtx _test_runner
		popd > /dev/null || die
	}

	multibuild_foreach_variant mytest
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install
}
