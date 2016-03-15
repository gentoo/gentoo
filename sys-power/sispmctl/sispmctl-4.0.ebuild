# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit bash-completion-r1 eutils user

DESCRIPTION="GEMBIRD SiS-PM control utility"
HOMEPAGE="http://sispmctl.sourceforge.net/"
SRC_URI="mirror://sourceforge/sispmctl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gemplug"

RDEPEND="virtual/libusb:0
	gemplug? ( sys-process/at )"
DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup sispmctl
}

src_configure() {
	econf --enable-webless
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README README.md ChangeLog NEWS

	## install udev rules which make the device files writable
	## by the members of the group sispmctl
	insinto /lib/udev/rules.d
	doins examples/60-sispmctl.rules

	## gemplug
	if use gemplug; then
		sed -i "s|/usr/local/bin/sispmctl|${ROOT:-/}usr/bin/sispmctl|g" extras/gemplug/gemplug
		dobin extras/gemplug/gemplug
		doman extras/gemplug/gemplug.1

		newbashcomp extras/gemplug/gemplug-completion.sh gemplug

		dodir /var/lock/gemplug
		fperms 2775 /var/lock/gemplug
		fowners root:sispmctl /var/lock/gemplug

		einfo "To be able to use the locking mechanism of gemplug(1),"
		einfo "add the users who are designated to run gemplug to the"
		einfo "group 'sispmctl' which has write permissions to /var/lock/gemplug."
	fi
}
