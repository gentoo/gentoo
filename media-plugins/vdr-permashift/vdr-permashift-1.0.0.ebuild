# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-permashift/vdr-permashift-1.0.0.ebuild,v 1.2 2015/02/03 09:13:21 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: permanent timeshift by recording live TV on RAM"
HOMEPAGE="http://ein-eike.de/vdr-plugin-permashift-english/"
SRC_URI="http://ein-eike.de/wordpress/wp-content/uploads/2014/08/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-2.0.6[permashift_v1]"
RDEPEND=""
