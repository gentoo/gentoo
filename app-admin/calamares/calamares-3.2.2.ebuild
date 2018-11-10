# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_5,3_6} )
inherit kde5 python-r1

DESCRIPTION="Distribution-independent installer framework"
HOMEPAGE="https://calamares.io"
if [[ ${KDE_BUILD_TYPE} == live ]] ; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN}"
else
	SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
IUSE="+networkmanager pythonqt +upower"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kpackage)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_qt_dep linguist-tools)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwebengine 'widgets')
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	dev-cpp/yaml-cpp:=
	>=dev-libs/boost-1.55:=[${PYTHON_USEDEP}]
	dev-libs/libpwquality[${PYTHON_USEDEP}]
	sys-apps/dbus
	sys-apps/dmidecode
	sys-auth/polkit-qt[qt5(+)]
	>=sys-libs/kpmcore-3.0.3:5=
	pythonqt? ( >=dev-python/PythonQt-3.1:=[${PYTHON_USEDEP}] )
"

RDEPEND="${DEPEND}
	app-admin/sudo
	dev-libs/libatasmart
	net-misc/rsync
	>=sys-block/parted-3.0
	|| ( sys-boot/grub:2 sys-boot/systemd-boot )
	sys-boot/os-prober
	sys-fs/squashfs-tools
	sys-libs/timezone-data
	virtual/udev
	networkmanager? ( net-misc/networkmanager )
	upower? ( sys-power/upower )
"

src_prepare() {
	cmake-utils_src_prepare
	python_setup
	export PYTHON_INCLUDE_DIRS="$(python_get_includedir)" \
	       PYTHON_INCLUDE_PATH="$(python_get_library_path)"\
	       PYTHON_CFLAGS="$(python_get_CFLAGS)"\
	       PYTHON_LIBS="$(python_get_LIBS)"
}

src_configure() {
	local mycmakeargs=(
		-DWEBVIEW_FORCE_WEBKIT=OFF
		-DWITH_PYTHONQT=$(usex pythonqt)
	)

	kde5_src_configure
	sed -i -e 's:pkexec /usr/bin/calamares:calamares-pkexec:' "${S}"/calamares.desktop
	sed -i -e 's:Icon=calamares:Icon=drive-harddisk:' "${S}"/calamares.desktop
}

src_install() {
	kde5_src_install
	dobin "${FILESDIR}"/calamares-pkexec
}
