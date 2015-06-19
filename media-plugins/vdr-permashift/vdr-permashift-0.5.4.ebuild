# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-permashift/vdr-permashift-0.5.4.ebuild,v 1.1 2013/06/05 15:47:16 hd_brummy Exp $

EAPI="5"

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: permanent timeshift by recording live TV on hard disk"
HOMEPAGE="http://ein-eike.de/vdr-plugin-permashift-english/"
SRC_URI="http://ein-eike.de/wordpress/wp-content/uploads/2013/05/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-2.0.2-r1[permashift]"
RDEPEND="${DEPEND}"
