# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
PYTHON_COMPAT=( python3_{10..12} )

QTMIN="6.7.1"
KFMIN="6.0.0"
inherit ecm python-single-r1

DESCRIPTION="Distribution-independent installer framework"
HOMEPAGE="https://calamares.io"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+networkmanager +upower"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-cpp/yaml-cpp:=
	$(python_gen_cond_dep '
		>=dev-libs/boost-1.72.0:=[python,${PYTHON_USEDEP}]
		dev-libs/libpwquality[${PYTHON_USEDEP}]
	')
	>=dev-qt/qtbase-${QTMIN}:6[concurrent,dbus,gui,network,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=dev-qt/qtwebengine-${QTMIN}:6[widgets]
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kpackage-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	sys-auth/polkit-qt[qt6(-)]
	>=sys-libs/kpmcore-24.01.75:6=
	sys-apps/dbus
	sys-apps/dmidecode
	virtual/libcrypt:=
"
RDEPEND="${DEPEND}
	app-admin/sudo
	dev-libs/libatasmart
	net-misc/rsync
	|| (
		sys-boot/grub:2
		sys-apps/systemd[boot(-)]
		sys-apps/systemd-utils[boot]
	)
	sys-boot/os-prober
	sys-fs/squashfs-tools
	sys-libs/timezone-data
	virtual/udev
	networkmanager? ( net-misc/networkmanager )
	upower? ( sys-power/upower )
"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

src_prepare() {
	ecm_src_prepare
	export PYTHON_INCLUDE_DIRS="$(python_get_includedir)" \
		PYTHON_INCLUDE_PATH="$(python_get_library_path)"\
		PYTHON_CFLAGS="$(python_get_CFLAGS)"\
		PYTHON_LIBS="$(python_get_LIBS)"

	cp "${FILESDIR}/calamares-gentoo-branding.desc" src/branding/default/branding.desc || die "Failed to overwrite branding file"
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_CONFIG=ON
		-DINSTALL_COMPLETION=ON
		-DINSTALL_POLKIT=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_LIBPARTED=ON
		-DWITH_PYTHON=ON
		# Use system instead
		-DWITH_PYBIND11=OFF
		-DBUILD_APPDATA=ON
		-DWITH_QT6=ON
	)

	ecm_src_configure
}

src_test() {
	local myctestargs=(
		# Skipped tests:
		# load-dracut: tries and fails to find Dracut config
		# libcalamaresnetworktest: needs network
		# libcalamaresutilstest: inspects /tmp (expects namespace?)
		#
		# Need investigation:
		# test_libcalamaresuipaste
		# validate-netinstall
		# validate-services-systemd
		# localetest
		# machineidtest
		# packagechoosertest
		#
		# Requires removed dev-python/toml
		# lint-displaymanager
		#
		# E1101
		# lint-dummypython
		-E "(load-dracut|libcalamaresnetworktest|libcalamaresutilstest|test_libcalamaresuipaste|validate-netinstall|validate-services-systemd|localetest|machineidtest|packagechoosertest|lint-displaymanager|lint-dummypython)"
	)

	cmake_src_test
}
