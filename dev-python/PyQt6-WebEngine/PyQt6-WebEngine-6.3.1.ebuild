# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=sip
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 flag-o-matic multiprocessing qmake-utils

QT_PV="6.3:6" # minimum tested qt version
MY_P="${P/-/_}"

DESCRIPTION="Python bindings for QtWebEngine"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqtwebengine/"
SRC_URI="mirror://pypi/${P::1}/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug quick +widgets"

RDEPEND="
	>=dev-python/PyQt6-${PV}[gui,ssl,${PYTHON_USEDEP}]
	>=dev-qt/qtbase-${QT_PV}
	>=dev-qt/qtwebengine-${QT_PV}[widgets]
	quick? ( dev-python/PyQt6[qml] )
	widgets? ( dev-python/PyQt6[network,printsupport,webchannel,widgets] )"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-python/PyQt-builder-1.11[${PYTHON_USEDEP}]
	>=dev-qt/qtbase-${QT_PV}
	sys-devel/gcc"

src_prepare() {
	default

	# hack: qmake wants g++ (not clang), try to respect ${CHOST} #726112
	mkdir "${T}"/cxx || die
	ln -s "$(type -P ${CHOST}-g++ || type -P g++ || die)" "${T}"/cxx/g++ || die
	PATH=${T}/cxx:${PATH}
}

src_configure() {
	append-cxxflags -std=c++17 # for clang and old gcc that default to <17

	# workaround until bug 863395 has something to offer
	local qmake6=$(qt5_get_bindir)/qmake6
	qmake6=${qmake6//qt5/qt6}

	DISTUTILS_ARGS=(
		--jobs=$(makeopts_jobs)
		--qmake="${qmake6}"
		--qmake-setting="$(qt5_get_qmake_args)"
		--verbose

		--enable=QtWebEngineCore
		$(usex quick --{enable,disable}=QtWebEngineQuick)
		$(usex widgets --{enable,disable}=QtWebEngineWidgets)

		$(usev debug '--debug --qml-debug --tracing')
	)
}
