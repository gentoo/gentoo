# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
PYTHON_COMPAT=( python3_{11..13} )

QTMIN="6.7.1"
KFMIN="6.9.0"
LIVEPATCH="${P}e"

inherit ecm python-single-r1 xdg

DESCRIPTION="Distribution-independent installer framework"
HOMEPAGE="https://calamares.io https://github.com/tableflipper9/calamares"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz
	livecd? (
		https://github.com/calamares/calamares/compare/95aa33f...TableFlipper9:calamares:gentoo-patches-3.3.14e.patch \
		-> ${LIVEPATCH}-gentoo-patches.patch
	)
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
IUSE="livecd"

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
	livecd? ( app-portage/gemato )
"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

src_prepare() {
	eapply "${FILESDIR}"/${P}-boost-python-fix.patch
	if use "livecd" ; then
		cp "${DISTDIR}/${LIVEPATCH}-gentoo-patches.patch" "${LIVEPATCH}-gentoo-patches.patch" || die
		eapply "${LIVEPATCH}-gentoo-patches.patch"
	fi

	ecm_src_prepare
	export PYTHON_INCLUDE_DIRS="$(python_get_includedir)" \
		PYTHON_INCLUDE_PATH="$(python_get_library_path)"\
		PYTHON_CFLAGS="$(python_get_CFLAGS)"\
		PYTHON_LIBS="$(python_get_LIBS)"
}

src_configure() {
	# get the selected Python version from EPYTHON variable
	local python_version="${EPYTHON#python}"
	local boost_python_component="${python_version/./}"

	local mycmakeargs=(
		-DINSTALL_CONFIG=ON
		-DINSTALL_COMPLETION=ON
		-DINSTALL_POLKIT=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_LIBPARTED=ON
		-DWITH_PYTHON=ON
		-DWITH_PYBIND11=OFF
		-DBUILD_APPDATA=ON
		-DWITH_QT6=ON
		# explicitly set Python version and paths
		-DPYTHONLIBS_VERSION="${python_version}"
		-DBOOSTPYTHON_COMPONENT="python${boost_python_component}"
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
