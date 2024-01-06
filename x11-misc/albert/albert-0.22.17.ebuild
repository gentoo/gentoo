# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10,11,12} )

inherit cmake python-single-r1 xdg

DESCRIPTION="A fast and flexible keyboard launcher"
HOMEPAGE="https://albertlauncher.github.io/"

PLUGINS_HASH="02755dfa0ef3f17c28a813355eb7db60642ee797"
PYTHON_EXTENSIONS_COMMIT="2067bbb3d8fa5cfa5df2be9cada29a7e6715f07a"

SRC_URI="
	https://github.com/albertlauncher/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/albertlauncher/plugins/archive/${PLUGINS_HASH}.tar.gz -> ${PN}-plugins-${PLUGINS_HASH}.tar.gz
	python-extensions? (
		https://github.com/albertlauncher/python/archive/${PYTHON_EXTENSIONS_COMMIT}.tar.gz ->
			${PN}-python-extensions-${PYTHON_EXTENSIONS_COMMIT}.tar.gz
	)
"

LICENSE="Albert-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug +python +python-extensions"
RESTRICT="mirror bindist"

REQUIRED_USE="
	python-extensions? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	app-arch/libarchive:=
	dev-libs/qhotkey[qt6]
	dev-qt/qt5compat:6[qml]
	dev-qt/qtbase:6[concurrent,dbus,gui,network,sql,sqlite,widgets]
	dev-qt/qtdeclarative:6
	dev-qt/qtscxml:6[qml]
	dev-qt/qtsvg:6
	sci-libs/libqalculate:=
	python? (
		$(python_gen_cond_dep 'dev-python/urllib3[${PYTHON_USEDEP}]')
		${PYTHON_DEPS}
	)
"
DEPEND="${RDEPEND}
	python? ( $(python_gen_cond_dep 'dev-python/pybind11[${PYTHON_USEDEP}]') )
	x11-base/xorg-proto"

PATCHES=("${FILESDIR}/${PN}-0.22.4-use-system-qhotkey-libraries-and-headers.patch")

src_prepare() {
	mv "${WORKDIR}"/plugins-${PLUGINS_HASH}/* "${S}"/plugins || die
	if use python-extensions; then
		mv "${WORKDIR}"/python-${PYTHON_EXTENSIONS_COMMIT}/* "${S}"/plugins/python/plugins || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DEBUG=$(usex debug)
		-DBUILD_PYTHON=$(usex python)
	)

	cmake_src_configure
}
