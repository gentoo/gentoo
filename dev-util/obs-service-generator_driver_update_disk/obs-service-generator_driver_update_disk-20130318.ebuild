# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/obs-service-generator_driver_update_disk/obs-service-generator_driver_update_disk-20130318.ebuild,v 1.2 2013/03/18 14:27:11 miska Exp $

EAPI=5

inherit obs-service

SRC_URI+=" ${OBS_URI}/BSKiwiXML.pm -> BSKiwiXML-${PV}.pm"

IUSE=""
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/perl
"

src_install() {
	obs-service_src_install

	insinto /usr/libexec/obs/service
	newins BSKiwiXML-${PV}.pm BSKiwiXML.pm
}
