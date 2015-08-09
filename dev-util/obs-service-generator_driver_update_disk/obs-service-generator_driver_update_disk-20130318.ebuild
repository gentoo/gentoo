# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
