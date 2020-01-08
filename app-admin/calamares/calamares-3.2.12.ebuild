# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="true"
PYTHON_COMPAT=( python3_6 )
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

BDEPEND="
	$(add_qt_dep linguist-tools)
"
COMMON_DEPEND="${PYTHON_DEPS}
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kpackage)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_qt_dep qtconcurrent)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwebengine 'widgets')
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	dev-cpp/yaml-cpp:=
	>=dev-libs/boost-1.55:=[python,${PYTHON_USEDEP}]
	dev-libs/libpwquality[${PYTHON_USEDEP}]
	sys-apps/dbus
	sys-apps/dmidecode
	sys-auth/polkit-qt[qt5(+)]
	>=sys-libs/kpmcore-4.0.0:5=
	pythonqt? ( >=dev-python/PythonQt-3.1:=[${PYTHON_USEDEP}] )
"
DEPEND="${COMMON_DEPEND}
	test? ( $(add_qt_dep qttest) )
"
RDEPEND="${COMMON_DEPEND}
	app-admin/sudo
	dev-libs/libatasmart
	net-misc/rsync
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

	sed -i -e 's:pkexec /usr/bin/calamares:calamares-pkexec:' \
		calamares.desktop || die
	sed -i -e 's:Icon=calamares:Icon=drive-harddisk:' \
		calamares.desktop || die
}

src_configure() {
	local mycmakeargs=(
		-DWEBVIEW_FORCE_WEBKIT=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_LIBPARTED=ON
		-DWITH_PYTHONQT=$(usex pythonqt)
	)

	kde5_src_configure
}

src_install() {
	kde5_src_install
	dobin "${FILESDIR}"/calamares-pkexec
}
