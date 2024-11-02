# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="$(ver_cut 1-2)"
MY_PV_DTC="3.5.0"
MY_P="kryoflux_${MY_PV}_linux_$(ver_cut 4)"
MY_P_DTC="${PN}-${MY_PV_DTC}-Linux"

inherit desktop udev wrapper xdg-utils

DESCRIPTION="KryoFlux Host Software"
HOMEPAGE="https://www.kryoflux.com"
SRC_URI="https://www.kryoflux.com/download/${MY_P}.tar.gz"
S="${WORKDIR}/Linux_Release${MY_PV}"

LICENSE="SPS"
SLOT="0"
KEYWORDS="-* amd64 ~arm64"
IUSE="demos doc gui"

RDEPEND="
	dev-libs/libfmt
	virtual/libusb:1
	gui? ( virtual/jre )
"

BDEPEND="app-arch/unzip"

DOCS=( "RELEASE.txt" )
RESTRICT="bindist mirror"
QA_PREBUILT="
	usr/lib64/libCAPSImage.so.5.2
	usr/bin/kryoflux-dtc
"

src_unpack() {
	unpack ${A}
	unpack Linux_Release${MY_PV}/dtc/$(usex amd64 x86_64 arm64)/${MY_P_DTC}.tar.gz
	use gui && unpack Linux_Release${MY_PV}/dtc/kryoflux-ui.jar
}

src_prepare() {
	default

	# Remove whitespace for demo files
	pushd testimages
	mv "G64 (C64)" g64_demo || die
	mv "IPF (Amiga, Atari ST)" ipf_demo || die
	popd
}

src_install() {
	newbin ../${MY_P_DTC}/bin/dtc kryoflux-dtc

	# We need to use bundled libs instead of 'dev-libs/spsdeclib',
	# as source code is currently not released.
	# See https://forum.kryoflux.com/viewtopic.php\?p\=17105
	dolib.so ../${MY_P_DTC}/lib/libCAPSImage.so.5.2

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
		pushd testimages
		dodoc -r g64_demo ipf_demo
		docompress -x /usr/share/doc/${PF}/g64_demo/BBSB/*.g64
		docompress -x /usr/share/doc/${PF}/g64_demo/DOTC/*.g64
		docompress -x /usr/share/doc/${PF}/ipf_demo/*.ipf
		popd
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
