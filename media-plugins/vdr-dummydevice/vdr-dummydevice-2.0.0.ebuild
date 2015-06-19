# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-dummydevice/vdr-dummydevice-2.0.0.ebuild,v 1.1 2015/02/23 16:47:53 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: dummy output device - for recording server without any output devices"
HOMEPAGE="http://phivdr.dyndns.org/vdr/${PN}/"
SRC_URI="http://phivdr.dyndns.org/vdr/${PN}/${P}.tgz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-2.0.0"
