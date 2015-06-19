# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/i8krellm/i8krellm-2.5-r1.ebuild,v 1.1 2010/08/11 13:37:36 lack Exp $

EAPI=3
inherit gkrellm-plugin

DESCRIPTION="GKrellM2 Plugin for the Dell Inspiron and Latitude notebooks"
SRC_URI="http://www.coding-zone.com/${P}.tar.gz"
HOMEPAGE="http://www.coding-zone.com/?page=i8krellm"
IUSE=""

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="-* ~x86"

RDEPEND=">=app-laptop/i8kutils-1.5"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-Respect-LDFLAGS.patch"
}
