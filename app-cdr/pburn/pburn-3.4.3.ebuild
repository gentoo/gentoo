# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# wget --user puppy --password linux "http://www.meownplanet.net/zigbert/${P}.pet"

EAPI=4
inherit eutils

DESCRIPTION="A burning tool with GTK+ frontend"
HOMEPAGE="http://murga-linux.com/puppy/viewtopic.php?t=23881"
SRC_URI="mirror://gentoo/${P}.pet"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-admin/killproc
	app-cdr/cddetect
	app-cdr/dvd+rw-tools
	sys-apps/hotplug2stdout
	virtual/cdrtools
	>=x11-misc/gtkdialog-0.8.0"
DEPEND="app-arch/pet2tgz"

src_unpack() {
	pet2tgz -i "${DISTDIR}"/${P}.pet -o "${WORKDIR}"/${P}.tar.gz
	unpack ./${P}.tar.gz
}

src_prepare() {
	cat <<-EOF > "${T}"/${PN}
	#!/bin/bash
	"/usr/share/${PN}/${PN}" "\$@"
	EOF

	sed -i -e 's:usleep:/sbin/&:' usr/local/pburn/box_splash || die
}

src_install() {
	dobin "${T}"/${PN}

	dodir /usr/share
	cp -dpR usr/local/${PN} "${D}"/usr/share || die

	make_desktop_entry \
		${PN} \
		"Pburn CD/DVD/Blu-ray writer" \
		/usr/share/${PN}/${PN}20.png \
		"AudioVideo;DiscBurning"

	dohtml -r usr/share/doc/${PN}
}
