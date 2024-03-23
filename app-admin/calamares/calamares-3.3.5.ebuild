# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
PYTHON_COMPAT=( python3_{10..11} )

inherit ecm python-single-r1

DESCRIPTION="Distribution-independent installer framework"
HOMEPAGE="https://calamares.io"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="5"
KEYWORDS="~amd64"
IUSE="+networkmanager qt6 +upower"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

QT5_MIN="5.15.0"
KF_QT5_MIN="5.78"
QT6_MIN="6.5.0"
KF_QT6_MIN="5.240"

BDEPEND="
	qt6? (
		>=dev-qt/qttools-${QT6_MIN}:6[linguist]
		>=kde-frameworks/extra-cmake-modules-${KF_QT6_MIN}
	)
	!qt6? (
		>=dev-qt/linguist-tools-${QT5_MIN}:5
		>=kde-frameworks/extra-cmake-modules-${KF_QT5_MIN}
	)
"
COMMON_DEPEND="${PYTHON_DEPS}
	dev-cpp/yaml-cpp:=
	$(python_gen_cond_dep '
		>=dev-libs/boost-1.72.0:=[python,${PYTHON_USEDEP}]
		dev-libs/libpwquality[${PYTHON_USEDEP}]
	')
	qt6? (
		>=dev-qt/qtbase-${QT6_MIN}:6[concurrent,dbus,gui,network,widgets,xml]
		>=dev-qt/qtdeclarative-${QT6_MIN}:6
		>=dev-qt/qtsvg-${QT6_MIN}:6
		>=dev-qt/qtwebengine-${QT6_MIN}:6[widgets]
		dev-qt/kdsingleapplication[qt6]
		>=kde-frameworks/kconfig-${KF_QT6_MIN}:6
		>=kde-frameworks/kcoreaddons-${KF_QT6_MIN}:6
		>=kde-frameworks/kcrash-${KF_QT6_MIN}:6
		>=kde-frameworks/ki18n-${KF_QT6_MIN}:6
		>=kde-frameworks/kpackage-${KF_QT6_MIN}:6
		>=kde-frameworks/kparts-${KF_QT6_MIN}:6
		>=kde-frameworks/kservice-${KF_QT6_MIN}:6
		>=kde-frameworks/kwidgetsaddons-${KF_QT6_MIN}:6
		sys-auth/polkit-qt[qt6(-)]
		>=sys-libs/kpmcore-24.01.75:6=
	)
	!qt6? (
		>=dev-qt/qtconcurrent-${QT5_MIN}:5
		>=dev-qt/qtdbus-${QT5_MIN}:5
		>=dev-qt/qtdeclarative-${QT5_MIN}:5
		>=dev-qt/qtgui-${QT5_MIN}:5
		>=dev-qt/qtnetwork-${QT5_MIN}:5
		>=dev-qt/qtsvg-${QT5_MIN}:5
		>=dev-qt/qtwebengine-${QT5_MIN}:5[widgets]
		>=dev-qt/qtwidgets-${QT5_MIN}:5
		>=dev-qt/qtxml-${QT5_MIN}:5
		dev-qt/kdsingleapplication[-qt6]
		>=kde-frameworks/kconfig-${KF_QT5_MIN}:5
		>=kde-frameworks/kcoreaddons-${KF_QT5_MIN}:5
		>=kde-frameworks/kcrash-${KF_QT5_MIN}:5
		>=kde-frameworks/ki18n-${KF_QT5_MIN}:5
		>=kde-frameworks/kpackage-${KF_QT5_MIN}:5
		>=kde-frameworks/kparts-${KF_QT5_MIN}:5
		>=kde-frameworks/kservice-${KF_QT5_MIN}:5
		>=kde-frameworks/kwidgetsaddons-${KF_QT5_MIN}:5
		sys-auth/polkit-qt[qt5(+)]
		>=sys-libs/kpmcore-20.04.0:5=
	)
	sys-apps/dbus
	sys-apps/dmidecode
	virtual/libcrypt:=
"
DEPEND="${COMMON_DEPEND}
	test? (
		!qt6? ( dev-qt/qttest:5 )
	)
"
RDEPEND="${COMMON_DEPEND}
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
		-DWITH_QT6="$(usex qt6)"
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

src_install() {
	ecm_src_install
	dobin "${FILESDIR}"/calamares-pkexec
}
