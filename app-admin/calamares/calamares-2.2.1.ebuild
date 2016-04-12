# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5} )
inherit kde5 python-r1

DESCRIPTION="Distribution-independent installer framework"
HOMEPAGE="http://calamares.io"
if [[ ${KDE_BUILD_TYPE} == live ]] ; then
	EGIT_REPO_URI="git://github.com/${PN}/${PN}"
	KEYWORDS=""
else
	SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
IUSE="+networkmanager +upower"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwebkit)
	$(add_qt_dep qtwidgets)
	>=dev-cpp/yaml-cpp-0.5.1
	>=dev-libs/boost-1.55:=[${PYTHON_USEDEP}]
	sys-apps/dbus
	sys-apps/dmidecode
	sys-auth/polkit-qt[qt5]
	>=sys-libs/kpmcore-2.1.0:5
"

RDEPEND="${DEPEND}
	app-admin/sudo
	dev-libs/libatasmart
	net-misc/rsync
	sys-apps/gptfdisk
	>=sys-block/parted-3.0
	|| ( sys-boot/grub:2 sys-boot/gummiboot )
	sys-boot/os-prober
	sys-fs/squashfs-tools
	sys-fs/udisks:2[systemd]
	virtual/udev[systemd]
	networkmanager? ( net-misc/networkmanager )
	upower? ( sys-power/upower )
"

src_prepare() {
	python_setup
	export PYTHON_INCLUDE_DIRS="$(python_get_includedir)" \
	       PYTHON_INCLUDE_PATH="$(python_get_library_path)"\
	       PYTHON_CFLAGS="$(python_get_CFLAGS)"\
	       PYTHON_LIBS="$(python_get_LIBS)"

	eapply_user
}

src_configure() {
	local mycmakeargs=( "-DWITH_PARTITIONMANAGER=1" )
	kde5_src_configure
	sed -i -e 's:pkexec /usr/bin/calamares:calamares-pkexec:' "${S}"/calamares.desktop
	sed -i -e 's:Icon=calamares:Icon=drive-harddisk:' "${S}"/calamares.desktop
}

src_install() {
	kde5_src_install
	dobin "${FILESDIR}"/calamares-pkexec
}
