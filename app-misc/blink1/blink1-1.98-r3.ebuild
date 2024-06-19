# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info toolchain-funcs

DESCRIPTION="blink(1) USB RGB LED status light control suite"
HOMEPAGE="https://blink1.thingm.com/"
SRC_URI="https://github.com/todbot/blink1/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${P}

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples +tool mini-tool server"
REQUIRED_USE="|| ( tool mini-tool server )"

RDEPEND="
	dev-libs/hidapi
	sys-apps/attr
	sys-libs/libcap
	virtual/libudev
	virtual/libusb:1
	mini-tool? ( virtual/libusb:0 )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-ldflags.patch"
)

pkg_setup() {
	local CONFIG_CHECK="USB_HID"
	linux-info_pkg_setup
}

src_compile() {
	tc-export CC
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

	if use server; then
		if use doc; then
			dodoc docs/{app-url-api.md,app-url-api-examples.md}
		fi

		dobin commandline/blink1-tiny-server
	fi

	if use tool; then
		if use doc; then
			dodoc docs/{blink1-tool.md,blink1-tool-tips.md,blink1-hid-commands.md,blink1-mk2-tricks.md}
		fi

		if use examples; then
			docinto examples
			dodoc commandline/scripts/{README.md,blink1-*.sh}
		fi

		dobin commandline/blink1-tool
	fi

	if use mini-tool; then
		dobin commandline/blink1-mini-tool/blink1-mini-tool
	fi
}
