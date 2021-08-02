# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit cmake linux-info python-single-r1 systemd udev

COMMIT="f8ef7e04b50a02a75f2fc68efbf80fb21580b675"
DESCRIPTION="Userspace Xbox 360 Controller driver"
HOMEPAGE="https://xboxdrv.gitlab.io"
SRC_URI="https://gitlab.com/xboxdrv/xboxdrv/-/archive/${COMMIT}/xboxdrv-${COMMIT}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-libs/argparser
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libfmt
	net-wireless/bluez
	sys-apps/dbus
	virtual/libudev:=
	>=virtual/libusb-1:=
	x11-libs/libX11
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3"

RDEPEND="${DEPEND}
	$(python_gen_cond_dep 'dev-python/dbus-python[${PYTHON_USEDEP}]')"

BDEPEND="dev-util/glib-utils
	virtual/pkgconfig
	test? ( dev-cpp/gtest )"

S="${WORKDIR}/${PN}-${COMMIT}"

PATCHES=( "${FILESDIR}"/xboxdrv-0.8.8_p20200909-use-system-argparser.patch )

# Needs more unbundling to work
RESTRICT="test"

CONFIG_CHECK="~INPUT_EVDEV ~INPUT_JOYDEV ~INPUT_UINPUT ~!JOYSTICK_XPAD"

pkg_setup() {
	linux-info_pkg_setup
	python_setup
}

src_prepare() {
	cmake_src_prepare

	# Don't build bundled libs
	sed -i '/subdirectory/d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test true false)
		-DWARNINGS=OFF
		-DWERROR=OFF
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}"/xboxdrv.initd xboxdrv
	newconfd "${FILESDIR}"/xboxdrv.confd xboxdrv

	insinto /etc/dbus-1/system.d
	doins "${FILESDIR}"/org.seul.Xboxdrv.conf

	udev_newrules "${FILESDIR}"/xboxdrv.udev-rules 99-xbox-controller.rules
	systemd_dounit "${FILESDIR}"/xboxdrv.service

	python_fix_shebang "${ED}"
}

pkg_postinst() {
	udev_reload
}
