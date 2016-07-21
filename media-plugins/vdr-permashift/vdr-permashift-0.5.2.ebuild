# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: permanent timeshift by recording live TV on hard disk"
HOMEPAGE="http://ein-eike.de/vdr-plugin-permashift-english/"
SRC_URI="http://ein-eike.de/wordpress/wp-content/uploads/2013/03/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.7.38[permashift]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${VDRPLUGIN}"
