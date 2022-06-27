# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="A fast and flexible keyboard launcher"
HOMEPAGE="https://albertlauncher.github.io/"

PLUGINS_HASH="b4cac28be7b265027b00279baba14086d97c4d07"
PYBIND11_VERSION="2.6.1"
PYTHON_EXTENSIONS_COMMIT="7f571aceaf8e60eee8bb21e1ec4efa0e95523d13"
JETBRAINS_PYTHON_EXTENSION_COMMIT="b7157473cc923fe4f15023c85a032eeab3627652"
XKCD_PYTHON_EXTENSION_COMMIT="bf88a964473d65b39c9e09eb48dabb847206f06f"

SRC_URI="
	https://github.com/albertlauncher/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/albertlauncher/plugins/archive/${PLUGINS_HASH}.tar.gz -> ${P}-plugins.tar.gz
	python? (
		https://github.com/pybind/pybind11/archive/v${PYBIND11_VERSION}.tar.gz -> ${P}-pybind11-${PYBIND11_VERSION}.tar.gz
	)
	python-extensions? (
		https://github.com/albertlauncher/python/archive/${PYTHON_EXTENSIONS_COMMIT}.tar.gz -> ${P}-python-extensions.tar.gz
		https://github.com/mqus/jetbrains-albert-plugin/archive/${JETBRAINS_PYTHON_EXTENSION_COMMIT}.tar.gz -> ${P}-jetbrains-python-extension.tar.gz
		https://github.com/bergercookie/xkcd-albert-plugin/archive/${XKCD_PYTHON_EXTENSION_COMMIT}.tar.gz -> ${P}-xkcd-python-extension.tar.gz
	)
"

LICENSE="all-rights-reserved"	# unclear licensing #766129
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug +python +python-extensions +statistics virtualbox"
RESTRICT="mirror bindist"

REQUIRED_USE="python-extensions? ( python )"

RDEPEND="
	dev-cpp/muParser
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgraphicaleffects:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	statistics? ( dev-qt/qtcharts:5 )
	virtualbox? ( app-emulation/virtualbox[sdk] )
	x11-libs/libX11
"
DEPEND="${RDEPEND}"

src_prepare() {
	mv "${WORKDIR}"/plugins-${PLUGINS_HASH}/* "${S}"/plugins || die
	if $(use python); then
		mv "${WORKDIR}"/pybind11-${PYBIND11_VERSION}/* "${S}"/plugins/python/pybind11 || die
	fi
	if $(use python-extensions); then
		mv "${WORKDIR}"/python-${PYTHON_EXTENSIONS_COMMIT}/* "${S}"/plugins/python/share/modules || die
		mv "${WORKDIR}"/jetbrains-albert-plugin-${JETBRAINS_PYTHON_EXTENSION_COMMIT}/* "${S}"/plugins/python/share/modules/jetbrains_projects || die
		mv "${WORKDIR}"/xkcd-albert-plugin-${XKCD_PYTHON_EXTENSION_COMMIT}/* "${S}"/plugins/python/share/modules/xkcd || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DEBUG=$(usex debug)
		-DBUILD_PYTHON=$(usex python)
		-DBUILD_VIRTUALBOX=$(usex virtualbox)
		-DBUILD_WITH_QTCHARTS=$(usex statistics)
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
