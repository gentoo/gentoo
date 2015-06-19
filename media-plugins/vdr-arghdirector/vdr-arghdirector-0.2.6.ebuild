# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-arghdirector/vdr-arghdirector-0.2.6.ebuild,v 1.10 2012/06/10 14:54:51 hd_brummy Exp $

EAPI="4"

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: use the multifeed option of some Premiere channels - fork of vdr-director"
HOMEPAGE="http://www.arghgra.de/arghdirector.html"
SRC_URI="http://www.arghgra.de/vdr-arghdirector-0.2.6.tar.gz
	mirror://vdrfiles/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=">=media-video/vdr-1.3.34"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-vdr-1.5.3.diff"
	"${FILESDIR}/${P}-i18n.patch"
	)
