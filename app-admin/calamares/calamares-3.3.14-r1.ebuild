# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
PYTHON_COMPAT=( python3_{11..13} )

QTMIN="6.7.1"
KFMIN="6.9.0"
inherit ecm python-single-r1 xdg

DESCRIPTION="Distribution-independent installer framework"
HOMEPAGE="https://calamares.io"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-cpp/yaml-cpp:=
	dev-libs/icu:=
	$(python_gen_cond_dep '
		>=dev-libs/boost-1.72.0:=[python,${PYTHON_USEDEP}]
		dev-libs/libpwquality[python,${PYTHON_USEDEP}]
	')
	>=dev-qt/qtbase-${QTMIN}:6[concurrent,dbus,gui,network,widgets,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kpackage-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	sys-apps/dmidecode
	>=sys-libs/kpmcore-24.01.75:6=
	virtual/libcrypt:=
"
RDEPEND="${DEPEND}
	app-admin/sudo
	net-misc/rsync
	sys-boot/grub:2
	sys-boot/os-prober
	sys-fs/squashfs-tools
	sys-libs/timezone-data
"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

src_prepare() {
	ecm_src_prepare
	export PYTHON_INCLUDE_DIRS="$(python_get_includedir)" \
		PYTHON_INCLUDE_PATH="$(python_get_library_path)"\
		PYTHON_CFLAGS="$(python_get_CFLAGS)"\
		PYTHON_LIBS="$(python_get_LIBS)"
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
		# packagechoosertest (file exists returned false)
		# partitiondevicestest for trying to access host
		# usershostnametest for changing hostname
		# displaymanager for testing access on host DMs
		#
		# Requires network
		# libcalamaresnetworktest
		# test_libcalamaresuipaste
		#
		# E1101
		# lint-dummypython
		#
		# E0606
		# lint-mount
		-E "(lint-displaymanager|lint-dummypython|lint-mount|validate-unpackfsc-unpackfsc|displaymanager|validate-unpackfsc-1|packagechoosertest|load-dummypython|load-dummypython-1|libcalamaresnetworktest|partitiondevicestest|usershostnametest|test_libcalamaresuipaste)"
	)

	cmake_src_test
}
