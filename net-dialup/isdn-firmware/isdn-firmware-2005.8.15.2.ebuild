# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/isdn-firmware/isdn-firmware-2005.8.15.2.ebuild,v 1.5 2014/05/24 21:48:03 jer Exp $

EAPI=5
inherit multilib rpm versionator

MY_PN="i4lfirm"
MY_PV="$(get_version_component_range 1-3)"
MY_PP="$(get_version_component_range 4)"
MY_P="${MY_PN}-${MY_PV}-${MY_PP}"

DESCRIPTION="ISDN firmware for active ISDN cards (AVM, Eicon, etc.)"
HOMEPAGE="http://www.isdn4linux.de/"
SRC_URI="ftp://ftp.man.poznan.pl/pub/linux/opensuse/opensuse/distribution/SL-10.0-OSS/inst-source/suse/i586/i586/${MY_P}.i586.rpm"

LICENSE="freedist"		#446158
SLOT="0"
KEYWORDS="amd64 ppc x86"

S="${WORKDIR}/lib/firmware/isdn"

src_install() {
	insinto $(get_libdir)/firmware
	insopts -m 0644
	doins *
}
