# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit epatch linux-info toolchain-funcs udev systemd

MY_PN=${PN/_/-}
MY_P=${MY_PN}-${PV/_p*}
#DATA_VER=${PV/*_p}
DATA_VER="20170806"

DESCRIPTION="A tool for controlling 'flip flop' (multiple devices) USB gear like UMTS sticks"
HOMEPAGE="https://www.draisberghof.de/usb_modeswitch/ https://www.draisberghof.de/usb_modeswitch/device_reference.txt"
SRC_URI="https://www.draisberghof.de/${PN}/${MY_P}.tar.bz2
	https://www.draisberghof.de/${PN}/${MY_PN}-data-${DATA_VER}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="jimtcl"

COMMON_DEPEND="
	virtual/udev
	virtual/libusb:1
"
RDEPEND="${COMMON_DEPEND}
	jimtcl? ( dev-lang/jimtcl )
	!jimtcl? ( dev-lang/tcl:0 )" # usb_modeswitch script is tcl
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"

S=${WORKDIR}/${MY_P}

CONFIG_CHECK="~USB_SERIAL"

src_prepare() {
	sed -i -e '/install.*BIN/s:-s::' Makefile || die
	epatch "${FILESDIR}/usb_modeswitch.sh-tmpdir.patch"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		SYSDIR="${D}/$(systemd_get_unitdir)" \
		UDEVDIR="${D}/$(get_udevdir)" \
		$(usex jimtcl install-shared install)

	# Even if we set SYSDIR above, the Makefile is causing automagic detection of `systemctl` binary,
	# which is why we need to force the .service file to be installed:
	systemd_dounit ${PN}@.service

	dodoc ChangeLog README

	pushd ../${MY_PN}-data-${DATA_VER} >/dev/null
	emake \
		DESTDIR="${D}" \
		RULESDIR="${D}/$(get_udevdir)/rules.d" \
		files-install db-install
	docinto data
	dodoc ChangeLog README
	popd >/dev/null
}
