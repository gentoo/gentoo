# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info

DESCRIPTION="blink(1) USB RGB LED status light control suite"
HOMEPAGE="https://blink1.thingm.com/"

## github release tarball
MY_PV=${PV/_rc/rc}
MY_P="${PN}-${MY_PV}"
SRC_URI="https://github.com/todbot/blink1/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

## selfmade tarball
#MY_PVR=${PVR/_rc/rc}
#MY_P="${PN}-${MY_PVR}"
#SRC_URI="https://dev.gentoo.org/~wschlich/src/${CATEGORY}/${PN}/${MY_P}.tar.gz"

## github commit tarball
#MY_GIT_COMMIT="1e9c012bd79cb99a53a22980fbaa6f97801e7c03"
#MY_P="todbot-${PN}-${MY_GIT_COMMIT:0:7}"
#SRC_URI="https://github.com/todbot/${PN}/tarball/${MY_GIT_COMMIT} -> ${PF}.tar.gz"

S="${WORKDIR}/${MY_P}"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="CC-BY-SA-3.0"
IUSE="doc examples +tool mini-tool server"

RDEPEND="dev-libs/hidapi
	virtual/libusb:1
	virtual/libudev
	sys-apps/attr
	sys-libs/libcap"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	## check for USB HID kernel support
	linux-info_pkg_setup
	CONFIG_CHECK="USB_HID"
	check_extra_config
	## check for acceptable USE flag settings
	if ! ( use tool || use mini-tool || use server ); then
		eerror "At least one of the following USE flags must be enabled:"
		eerror "tool, mini-tool, server"
		die "unacceptable USE flag settings"
	fi
}

src_compile() {
	if use tool; then
		pushd commandline &>/dev/null
		# USBLIB_TYPE=HIDAPI
		# USBLIB_TYPE=HIDAPI_HIDRAW
		# USBLIB_TYPE=HIDDATA
		emake OS=linux USBLIB_TYPE=HIDAPI blink1-tool
		popd &>/dev/null
	fi
	if use mini-tool; then
		pushd commandline/blink1-mini-tool &>/dev/null
		emake OS=linux blink1-mini-tool
		popd &>/dev/null
	fi
	if use server; then
		pushd commandline &>/dev/null
		emake OS=linux blink1-tiny-server
		popd &>/dev/null
	fi
}

src_install() {
	if use doc; then
		dodoc docs/README.md
	fi
	if use tool; then
		if use doc; then
			dodoc docs/{blink1-tool.md,blink1-tool-tips.md,blink1-hid-commands.md,blink1-mk2-tricks.md}
		fi
		if use examples; then
			insinto /usr/share/doc/"${PF}"/examples
			doins commandline/scripts/{README.md,blink1-*.sh}
			docompress -x /usr/share/doc/"${PF}"/examples
		fi
		dobin commandline/blink1-tool
	fi
	if use mini-tool; then
		dobin commandline/blink1-mini-tool/blink1-mini-tool
	fi
	if use server; then
		if use doc; then
			dodoc docs/{app-url-api.md,app-url-api-examples.md}
		fi
		dobin commandline/blink1-tiny-server
	fi
}
