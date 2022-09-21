# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit desktop systemd udev xdg-utils distutils-r1 python-r1 linux-mod

DESCRIPTION="Drivers and user-space daemon to control Razer devices on GNU/Linux"
HOMEPAGE="https://openrazer.github.io/
	https://github.com/openrazer/openrazer/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+client +daemon"
REQUIRED_USE="
	client? ( daemon )
	daemon? ( ${PYTHON_REQUIRED_USE} )
	test? ( daemon )
"

RDEPEND="
	client? ( dev-python/numpy[${PYTHON_USEDEP}] )
	daemon? (
		acct-group/plugdev
		dev-python/daemonize[${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/notify2[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/pyudev[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
		x11-libs/gtk+:3[introspection]
		x11-misc/xautomation
		x11-misc/xdotool
	)
"
BDEPEND="
	${RDEPEND}
	virtual/linux-sources
"

DOCS=( README.md )

# This is a bit weird, but it's end result is what we want.
BUILD_TARGETS="clean driver"
BUILD_PARAMS="-C ${S} SUBDIRS=${S}/driver KERNELDIR=${KERNEL_DIR}"
MODULE_NAMES="
	razeraccessory(hid:${S}/driver)
	razerkbd(hid:${S}/driver)
	razerkraken(hid:${S}/driver)
	razermouse(hid:${S}/driver)
"

distutils_enable_tests unittest

python_compile() {
	if use daemon ; then
		( cd "${S}"/daemon || die ; distutils-r1_python_compile )
	fi
	if use client ; then
		( cd "${S}"/pylib || die ; distutils-r1_python_compile )
	fi
}

python_install() {
	if use daemon ; then
		( cd "${S}"/daemon || die ; distutils-r1_python_install )
		python_scriptinto /usr/bin
		python_newscript "${S}"/daemon/run_openrazer_daemon.py ${PN}-daemon
	fi
	if use client ; then
		( cd "${S}"/pylib || die ; distutils-r1_python_install )
	fi
}

src_prepare() {
	xdg_environment_reset
	distutils-r1_src_prepare

	# Remove bad tests.
	rm "${S}"/daemon/tests/test_effect_sync.py || die
}

src_compile() {
	linux-mod_src_compile
	distutils-r1_src_compile

	if use daemon ; then
		emake -C "${S}"/daemon PREFIX=/usr service
	fi
}

src_test() {
	( cd "${S}"/daemon/tests || die ; distutils-r1_src_test )
}

src_install() {
	linux-mod_src_install
	distutils-r1_src_install

	udev_dorules "${S}"/install_files/udev/99-razer.rules
	exeinto "$(get_udevdir)"
	doexe "${S}"/install_files/udev/razer_mount

	# Install configuration example so that the daemon does not complain.
	insinto /usr/share/${PN}
	newins "${S}"/daemon/resources/razer.conf razer.conf.example

	if use daemon ; then
		# systemd units
		systemd_dounit "${S}"/daemon/org.razer.service
		systemd_dounit "${S}"/daemon/${PN}-daemon.service
		# Manpages
		doman "${S}"/daemon/resources/man/${PN}-daemon.8
		doman "${S}"/daemon/resources/man/razer.conf.5
		# Autostart menu
		newicon logo/${PN}-chroma.svg ${PN}-daemon.svg
		domenu "${S}"/install_files/desktop/${PN}-daemon.desktop
	fi
}

pkg_postinst() {
	linux-mod_pkg_postinst
	udev_reload

	if use daemon ; then
		xdg_icon_cache_update
		xdg_desktop_database_update
	fi
}

pkg_postrm() {
	linux-mod_pkg_postrm
	udev_reload

	if use daemon ; then
		xdg_icon_cache_update
		xdg_desktop_database_update
	fi
}
