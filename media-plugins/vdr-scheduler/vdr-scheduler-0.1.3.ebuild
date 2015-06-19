# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-scheduler/vdr-scheduler-0.1.3.ebuild,v 1.2 2012/05/06 19:14:06 hd_brummy Exp $

EAPI="4"

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: allows to control externel jobs from within VDR"
HOMEPAGE="http://winni.vdr-developer.org/scheduler/index.html"
SRC_URI="http://winni.vdr-developer.org/scheduler/downloads/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-video/vdr-1.5.7"
