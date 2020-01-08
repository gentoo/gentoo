# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="kryoflux_${PV}_linux"

inherit desktop eutils udev xdg-utils

DESCRIPTION="KryoFlux Host Software"
HOMEPAGE="https://www.kryoflux.com"
SRC_URI="https://www.kryoflux.com/download/${MY_P}.tar.bz2
	gui? ( https://www.kryoflux.com/kryoflux-ui.jar )"

KEYWORDS="-* amd64 x86"
LICENSE="SPS"
SLOT="0"
IUSE="demos doc fast-firmware gui static"

RDEPEND="dev-libs/spsdeclib
	virtual/libusb:1
	virtual/udev
	gui? ( virtual/jre )"

DEPEND="app-arch/unzip"

RESTRICT="bindist mirror strip"

S="${WORKDIR}/${MY_P}"

QA_PREBUILT="/usr/bin/kryoflux-dtc"

src_unpack() {
	unpack ${MY_P}.tar.bz2

	if use gui; then
		# Updated *.jar for compatibility with >= Java 9
		cp "${DISTDIR}"/kryoflux-ui.jar "${S}" || die

		# Extract kryoflux-ui.jar to get a logo for the meny entry
		unpack kryoflux-ui.jar
	fi
}

src_install() {
	newbin dtc/$(usex amd64 x86_64 i686)/$(usex static static dynamic)/dtc kryoflux-dtc

	cat <<-EOF > "${T}"/80-kryoflux.rules || die
	ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="03eb", ATTR{idProduct}=="6124", GROUP="floppy", MODE="0660"
	EOF
	udev_dorules "${T}"/80-kryoflux.rules

	if use gui; then
		insinto /usr/share/kryoflux-ui
		doins kryoflux-ui.jar

		dosym ../../bin/kryoflux-dtc /usr/share/kryoflux-ui/dtc

		make_wrapper kryoflux-ui "java -jar kryoflux-ui.jar" /usr/share/kryoflux-ui

		newicon "${WORKDIR}"/images/disk.png kryoflux-ui.png

		make_desktop_entry "kryoflux-ui" "KryoFlux UI" kryoflux-ui Development

		dodoc dtc/kryoflux-ui_README.txt
	fi

	if use fast-firmware; then
		insinto /lib/firmware
		doins dtc/firmware_fast/firmware_kf_usb_rosalie.bin

		dodoc dtc/firmware_fast/firmware_fast_README.txt
	else
		insinto /lib/firmware
		doins dtc/firmware_kf_usb_rosalie.bin
	fi

	if use demos; then
		dodoc -r g64_demo ipf_demo
	fi

	if use doc; then
		dodoc -r docs schematics
	fi

	local DOCS=( "DONATIONS.txt" "RELEASE.txt" "README.linux" )
	einstalldocs
}

pkg_postinst() {
	elog "If you want to access your Kryoflux without root access,"
	elog "please add yourself to the floppy group."

	if use fast-firmware; then
		elog ""
		elog "You have enabled the fast firmware. Please keep in mind,"
		elog "that this firmware can cause trouble with older floppy drives."
	fi

	if use gui; then
		xdg_desktop_database_update
		xdg_mimeinfo_database_update
	fi
}
