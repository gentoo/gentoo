# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/danvratil/${PN/5/}"
else
	SRC_URI="https://github.com/danvratil/${PN/5/}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${P/5/}"
	KEYWORDS="~amd64 ~arm64 ~ppc64"
fi

DESCRIPTION="C++ Coroutine Library for Qt5"
HOMEPAGE="https://qcoro.dvratil.cz/ https://github.com/danvratil/qcoro"

LICENSE="MIT"
SLOT="0"
IUSE="dbus examples +network test websockets"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qtcore:5
	dbus? ( dev-qt/qtdbus:5 )
	network? ( dev-qt/qtnetwork:5 )
	websockets? ( dev-qt/qtwebsockets:5 )
"
DEPEND="${RDEPEND}
	examples? (
		dev-qt/qtconcurrent:5
		dev-qt/qtwidgets:5
	)
	test? (
		dev-qt/qtconcurrent:5
		dev-qt/qttest:5
	)
"

src_configure() {
	local mycmakeargs=(
		-DUSE_QT_VERSION=5
		-DQCORO_BUILD_EXAMPLES=$(usex examples)
		-DQCORO_WITH_QTDBUS=$(usex dbus)
		-DQCORO_WITH_QTNETWORK=$(usex network)
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
