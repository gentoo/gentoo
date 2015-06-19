# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-nordlichtsepg/vdr-nordlichtsepg-0.9_pre1.ebuild,v 1.3 2014/02/23 20:30:46 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

IUSE=""
SLOT="0"

MY_P="${PN}-${PV/_pre/-test}"

DESCRIPTION="vdr Plugin: Better EPG view than default vdr"
HOMEPAGE="http://martins-kabuff.de/nordlichtsepg.html"
SRC_URI="http://martins-kabuff.de/download/${MY_P}.tgz"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~x86"

DEPEND=">=media-video/vdr-1.3.31"

S="${WORKDIR}/${PN#vdr-}-${PV%_pre*}"
