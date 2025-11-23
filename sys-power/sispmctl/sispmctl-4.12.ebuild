# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd udev

DESCRIPTION="GEMBIRD SiS-PM control utility"
HOMEPAGE="https://sispmctl.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/sispmctl/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="static-libs"

DEPEND="
	virtual/libusb:0
"
RDEPEND="
	${DEPEND}
	acct-group/sispmctl
"

src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		--enable-webless
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	# install udev rules which make the device files writable
	# by the members of the group sispmctl
	udev_dorules examples/60-sispmctl.rules

	systemd_dounit examples/${PN}.service
}

pkg_postinst() {
	udev_reload
	einfo "Add users who may run ${PN} to the group '${PN}'"
}

pkg_postrm() {
	udev_reload
}
