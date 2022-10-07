# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit cmake python-single-r1 xdg-utils

DESCRIPTION="A fast and flexible keyboard launcher"
HOMEPAGE="https://albertlauncher.github.io/"

PLUGINS_HASH="22881af568d70a3d4c16a901cd49c0e233c14a7a"
PYTHON_EXTENSIONS_COMMIT="7f571aceaf8e60eee8bb21e1ec4efa0e95523d13"
JETBRAINS_PYTHON_EXTENSION_COMMIT="b7157473cc923fe4f15023c85a032eeab3627652"
XKCD_PYTHON_EXTENSION_COMMIT="bf88a964473d65b39c9e09eb48dabb847206f06f"

SRC_URI="
	https://github.com/albertlauncher/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/albertlauncher/plugins/archive/${PLUGINS_HASH}.tar.gz -> ${PN}-plugins-${PLUGINS_HASH}.tar.gz
	python-extensions? (
		https://github.com/albertlauncher/python/archive/${PYTHON_EXTENSIONS_COMMIT}.tar.gz -> ${PN}-python-extensions-${PYTHON_EXTENSIONS_COMMIT}.tar.gz
		https://github.com/mqus/jetbrains-albert-plugin/archive/${JETBRAINS_PYTHON_EXTENSION_COMMIT}.tar.gz -> ${PN}-jetbrains-python-extension-${JETBRAINS_PYTHON_EXTENSION_COMMIT}.tar.gz
		https://github.com/bergercookie/xkcd-albert-plugin/archive/${XKCD_PYTHON_EXTENSION_COMMIT}.tar.gz -> ${PN}-xkcd-python-extension-${XKCD_PYTHON_EXTENSION_COMMIT}.tar.gz
	)
"

LICENSE="all-rights-reserved"	# unclear licensing #766129
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug +python +python-extensions +statistics virtualbox"
RESTRICT="mirror bindist"

REQUIRED_USE="
	python-extensions? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
"

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
	x11-libs/libX11
	python? ( ${PYTHON_DEPS} )
	statistics? (
		dev-qt/qtcharts:5
		dev-qt/qtxml:5
	)
	virtualbox? ( app-emulation/virtualbox[sdk,vboxwebsrv] )
"
DEPEND="${RDEPEND}
	python? ( $(python_gen_cond_dep 'dev-python/pybind11[${PYTHON_USEDEP}]') )"

PATCHES=("${FILESDIR}/${PN}-0.17.3-find-and-use-python-libraries-and-headers.patch")

src_prepare() {
	mv "${WORKDIR}"/plugins-${PLUGINS_HASH}/* "${S}"/plugins || die
	if use python-extensions; then
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
