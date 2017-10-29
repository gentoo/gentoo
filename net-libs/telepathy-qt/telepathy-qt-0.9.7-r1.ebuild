# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 cmake-utils virtualx

DESCRIPTION="Qt bindings for the Telepathy D-Bus protocol"
HOMEPAGE="https://telepathy.freedesktop.org/"
SRC_URI="https://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug farstream test"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
	farstream? (
		>=net-libs/telepathy-farstream-0.2.2
		>=net-libs/telepathy-glib-0.18.0
	)
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	test? (
		dev-libs/dbus-glib
		dev-libs/glib:2
		dev-python/dbus-python
		dev-qt/qttest:5
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-0.9.6.1-yes-release.patch"
	"${FILESDIR}/${PN}-0.9.6.1-qtpath.patch"
)

# bug 549448 - last checked with 0.9.7
RESTRICT="test"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DDESIRED_QT_VERSION=5
		-DENABLE_DEBUG_OUTPUT=$(usex debug)
		-DENABLE_FARSTREAM=$(usex farstream)
		-DENABLE_TESTS=$(usex test)
		-DENABLE_EXAMPLES=OFF
	)
	cmake-utils_src_configure
}

src_test() {
	_test_runner() {
		ctest -E '(CallChannel)'
	}

	pushd "${BUILD_DIR}" > /dev/null || die
	virtx _test_runner
	popd > /dev/null || die
}
