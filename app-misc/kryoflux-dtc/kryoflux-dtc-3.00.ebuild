# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="kryoflux_${PV}_linux"
MY_PV_DTC="3.0.0"
MY_P_DTC="dtc-${MY_PV_DTC}-Linux"
MY_P_WINDOWS="${MY_P/linux/windows}"

inherit desktop udev wrapper xdg-utils

DESCRIPTION="KryoFlux Host Software"
HOMEPAGE="https://www.kryoflux.com"
SRC_URI="https://www.kryoflux.com/download/${MY_P}.tgz"
S="${WORKDIR}/${MY_P}"

KEYWORDS="-* amd64 ~arm64"
LICENSE="SPS"
SLOT="0"
IUSE="demos doc gui"

RDEPEND="
	dev-libs/spsdeclib
	virtual/libusb:1
	gui? ( virtual/jre )
"

BDEPEND="
	app-arch/unzip
	dev-util/patchelf
"

DOCS=( "DONATIONS.txt" "RELEASE.txt" )
RESTRICT="bindist mirror"
QA_PREBUILT="/usr/bin/kryoflux-dtc"

src_unpack() {
	unpack ${A}
	unpack ${MY_P}/dtc/$(usex amd64 x86_64 aarch64)/${MY_P_DTC}.tar.gz
	use gui && unpack ${MY_P}/dtc/kryoflux-ui.jar
}

src_prepare() {
	default

	# Upstream uses 'libCAPSImage.so.5.1' (uppercase),
	# but their source installs 'libcapsimage.so.5' (lowercase)
	patchelf --replace-needed libCAPSImage.so.5.1 libcapsimage.so.5 ../${MY_P_DTC}/bin/dtc
}

src_install() {
	newbin ../${MY_P_DTC}/bin/dtc kryoflux-dtc

	insinto /lib/firmware
	doins ../${MY_P_DTC}/share/dtc/firmware_kf_usb_rosalie.bin

	cat <<-EOF > "${T}"/80-kryoflux.rules || die
	ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="03eb", ATTR{idProduct}=="6124", GROUP="floppy", MODE="0660"
	EOF
	udev_dorules "${T}"/80-kryoflux.rules

	if use gui; then
		insinto /usr/share/kryoflux-ui
		doins dtc/kryoflux-ui.jar

		dosym ../../bin/kryoflux-dtc /usr/share/kryoflux-ui/dtc
		make_wrapper kryoflux-ui "java -jar kryoflux-ui.jar" /usr/share/kryoflux-ui

		newicon ../images/disk.png kryoflux-ui.png
		make_desktop_entry "kryoflux-ui" "KryoFlux UI" kryoflux-ui Development
		dodoc dtc/kryoflux-ui_README.txt
	fi

	if use demos; then
		dodoc -r g64_demo ipf_demo
		docompress -x /usr/share/doc/${PF}/g64_demo/BBSB/*.g64
		docompress -x /usr/share/doc/${PF}/g64_demo/DOTC/*.g64
		docompress -x /usr/share/doc/${PF}/ipf_demo/*.ipf
	fi

	if use doc; then
		dodoc -r docs schematics
		docompress -x /usr/share/doc/${PF}/{docs,schematics}/*.pdf
	fi

	einstalldocs
}

pkg_postinst() {
	elog "If you want to access your Kryoflux without root access,"
	elog "please add yourself to the floppy group."

	udev_reload

	if use gui; then
		xdg_desktop_database_update
		xdg_mimeinfo_database_update
	fi
}

pkg_postrm() {
	udev_reload

	if use gui; then
		xdg_desktop_database_update
		xdg_mimeinfo_database_update
	fi
}
