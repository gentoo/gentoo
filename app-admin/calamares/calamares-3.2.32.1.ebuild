# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="true"
PYTHON_COMPAT=( python3_{7..9} )

inherit ecm python-single-r1

DESCRIPTION="Distribution-independent installer framework"
HOMEPAGE="https://calamares.io"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="5"
KEYWORDS="~amd64"
IUSE="+networkmanager +upower"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	dev-qt/linguist-tools:5
"
COMMON_DEPEND="${PYTHON_DEPS}
	dev-cpp/yaml-cpp:=
	$(python_gen_cond_dep '
		>=dev-libs/boost-1.55:=[python,${PYTHON_MULTI_USEDEP}]
		dev-libs/libpwquality[${PYTHON_MULTI_USEDEP}]
	')
	dev-qt/qtconcurrent:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwebengine:5[widgets]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	kde-frameworks/kconfig:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/kcrash:5
	kde-frameworks/kpackage:5
	kde-frameworks/kparts:5
	kde-frameworks/kservice:5
	sys-apps/dbus
	sys-apps/dmidecode
	sys-auth/polkit-qt
	>=sys-libs/kpmcore-4.0.0:5=
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-qt/qttest:5 )
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

PATCHES=( "${FILESDIR}"/${PN}-3.2.32.1-remove-broken-tests.ebuild )

src_prepare() {
	ecm_src_prepare
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
		-DINSTALL_CONFIG=ON
		-DWEBVIEW_FORCE_WEBKIT=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_LIBPARTED=ON
		-DWITH_PYTHONQT=OFF
	)

	ecm_src_configure
}

src_install() {
	ecm_src_install
	dobin "${FILESDIR}"/calamares-pkexec
}
