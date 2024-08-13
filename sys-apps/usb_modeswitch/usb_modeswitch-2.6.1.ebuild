# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info systemd toolchain-funcs udev

MY_PN=${PN/_/-}
MY_P=${MY_PN}-${PV/_p*}
#DATA_VER=${PV/*_p}
DATA_VER="20191128"

DESCRIPTION="Tool for controlling 'flip flop' (multiple devices) USB gear like UMTS sticks"
HOMEPAGE="https://www.draisberghof.de/usb_modeswitch/ https://www.draisberghof.de/usb_modeswitch/device_reference.txt"
SRC_URI="https://www.draisberghof.de/${PN}/${MY_P}.tar.bz2
	https://www.draisberghof.de/${PN}/${MY_PN}-data-${DATA_VER}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86"

RDEPEND="
	virtual/udev
	virtual/libusb:1
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

CONFIG_CHECK="~USB_SERIAL"

PATCHES=( "${FILESDIR}/usb_modeswitch.sh-tmpdir.patch" )

src_prepare() {
	default
	sed -i -e '/install.*BIN/s:-s::' Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		SYSDIR="${D}/$(systemd_get_systemunitdir)" \
		UDEVDIR="${D}/${EPREFIX}$(get_udevdir)" \
		install

	# Even if we set SYSDIR above, the Makefile is causing automagic detection of `systemctl` binary,
	# which is why we need to force the .service file to be installed:
	systemd_dounit ${PN}@.service

	dodoc ChangeLog README

	pushd ../${MY_PN}-data-${DATA_VER} &>/dev/null || die
	emake \
		DESTDIR="${D}" \
		RULESDIR="${D}/${EPREFIX}$(get_udevdir)/rules.d" \
		files-install db-install
	docinto data
	dodoc ChangeLog README
	popd &>/dev/null || die

	keepdir /var/lib/${PN}
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
