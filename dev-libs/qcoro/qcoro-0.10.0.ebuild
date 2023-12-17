# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/danvratil/${PN}"
else
	SRC_URI="https://github.com/danvratil/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="C++ Coroutine Library for Qt"
HOMEPAGE="https://qcoro.dvratil.cz/ https://github.com/danvratil/qcoro"

LICENSE="MIT"
SLOT="0"
IUSE="dbus examples +network qml test testlib websockets"

REQUIRED_USE="examples? ( network ) test? ( testlib )"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qtbase:6[dbus?,network?]
	qml? ( dev-qt/qtdeclarative:6= )
	testlib? ( dev-qt/qtbase:6[test] )
	websockets? ( dev-qt/qtwebsockets:6 )
"
DEPEND="${RDEPEND}
	examples? ( dev-qt/qtbase:6[concurrent,network,widgets] )
	test? ( dev-qt/qtbase:6[concurrent,test] )
"

src_configure() {
	local mycmakeargs=(
		-DUSE_QT_VERSION=6
		-DQCORO_BUILD_EXAMPLES=$(usex examples)
		-DQCORO_WITH_QTDBUS=$(usex dbus)
		-DQCORO_WITH_QTNETWORK=$(usex network)
		-DQCORO_WITH_QML=$(usex qml)
		-DQCORO_WITH_QTQUICK=$(usex qml)
		-DQCORO_WITH_QTTEST=$(usex testlib)
		-DBUILD_TESTING=$(usex test)
		-DQCORO_WITH_QTWEBSOCKETS=$(usex websockets)
	)
	cmake_src_configure
}

src_install() {
	if use examples; then
		docinto examples
		dodoc -r examples/*
	fi
	cmake_src_install
}
