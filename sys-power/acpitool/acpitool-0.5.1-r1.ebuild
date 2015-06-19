# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/acpitool/acpitool-0.5.1-r1.ebuild,v 1.4 2014/06/05 09:57:01 ssuominen Exp $

EAPI=5
inherit eutils

DESCRIPTION="A small command line application, intended to be a replacement for the apm tool"
HOMEPAGE="http://packages.debian.org/sid/acpitool"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DOCS="AUTHORS ChangeLog README TODO"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-ac_adapter.patch \
		"${FILESDIR}"/${P}-battery.patch \
		"${FILESDIR}"/${P}-kernel3.patch \
		"${FILESDIR}"/${P}-wakeup.patch
}
