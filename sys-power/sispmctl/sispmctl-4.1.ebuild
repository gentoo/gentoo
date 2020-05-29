# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 systemd udev user

DESCRIPTION="GEMBIRD SiS-PM control utility"
HOMEPAGE="http://sispmctl.sourceforge.net/"
SRC_URI="mirror://sourceforge/sispmctl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="static-libs"

RDEPEND="
	virtual/libusb:0
"
DEPEND="
	${RDEPEND}
"
DOCS="AUTHORS README ChangeLog"

pkg_setup() {
	enewgroup ${PN}
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--enable-webless
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	## install udev rules which make the device files writable
	## by the members of the group sispmctl
	udev_dorules examples/60-sispmctl.rules

	systemd_dounit examples/${PN}.service

	einfo "Add users who may run ${PN} to the group '${PN}'"
}
