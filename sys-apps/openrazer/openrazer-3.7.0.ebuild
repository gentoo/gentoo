# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit readme.gentoo-r1 systemd udev xdg-utils distutils-r1 linux-mod-r1

DESCRIPTION="Drivers and user-space daemon to control Razer devices on GNU/Linux"
HOMEPAGE="https://openrazer.github.io/
	https://github.com/openrazer/openrazer/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

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

DOC_CONTENTS="To successfully use OpenRazer: load desired kernel module
(razeraccessory, razerkbd, razerkraken and/or razermouse),
add your user to the \"plugdev\" group and start the OpenRazer daemon.
To automatically start up the OpenRazer daemon on session login copy
/usr/share/openrazer/openrazer-daemon.desktop file into Your user's
~/.config/autostart/ directory."

distutils_enable_tests unittest

python_compile() {
	cd "${S}/daemon" || die

	distutils_pep517_install "${BUILD_DIR}/install"

	if use client ; then
		cd "${S}/pylib" || die

		distutils_pep517_install "${BUILD_DIR}/install"
	fi
}

python_install() {
	distutils-r1_python_install

	python_scriptinto /usr/bin
	python_newscript daemon/run_openrazer_daemon.py "${PN}-daemon"
}

src_prepare() {
	xdg_environment_reset

	if use daemon ; then
		distutils-r1_src_prepare
	else
		default
	fi

	# Remove bad tests.
	rm daemon/tests/test_effect_sync.py || die
}

src_compile() {
	local -a modargs=(
		SUBDIRS="${S}/driver"
		KERNELDIR="${KERNEL_DIR}"
	)
	local -a modlist=(
		{razeraccessory,razerkbd,razerkraken,razermouse}="hid:${S}:driver"
	)
	linux-mod-r1_src_compile

	if use daemon ; then
		distutils-r1_src_compile

		emake -C "${S}/daemon" PREFIX=/usr service
	fi

	readme.gentoo_create_doc
}

src_test() {
	cd daemon/tests || die

	distutils-r1_src_test
}

src_install() {
	linux-mod-r1_src_install

	udev_dorules install_files/udev/99-razer.rules
	exeinto "$(get_udevdir)"
	doexe install_files/udev/razer_mount

	# Install configuration example so that the daemon does not complain.
	insinto /usr/share/${PN}
	newins daemon/resources/razer.conf razer.conf.example

	if use daemon ; then
		# Python libraries/scripts, "client" also requires USE="daemon"
		distutils-r1_src_install

		# dbus service
		insinto /usr/share/dbus-1/services
		doins daemon/org.razer.service

		# systemd unit
		systemd_douserunit "daemon/${PN}-daemon.service"

		# xdg autostart example file
		insinto /usr/share/${PN}
		doins install_files/desktop/openrazer-daemon.desktop

		# Manpages
		doman daemon/resources/man/${PN}-daemon.8
		doman daemon/resources/man/razer.conf.5
	fi
}

pkg_postinst() {
	linux-mod-r1_pkg_postinst
	udev_reload

	if use daemon ; then
		xdg_icon_cache_update
		xdg_desktop_database_update
	fi

	readme.gentoo_print_elog
}

pkg_postrm() {
	udev_reload

	if use daemon ; then
		xdg_icon_cache_update
		xdg_desktop_database_update
	fi
}
