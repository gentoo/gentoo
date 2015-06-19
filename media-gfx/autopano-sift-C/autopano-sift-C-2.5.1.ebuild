# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/autopano-sift-C/autopano-sift-C-2.5.1.ebuild,v 1.9 2015/01/05 10:13:04 pinkbyte Exp $

EAPI=5
inherit cmake-utils eutils versionator

DESCRIPTION="SIFT algorithm for automatic panorama creation in C"
HOMEPAGE="http://hugin.sourceforge.net/ http://user.cs.tu-berlin.de/~nowozin/autopano-sift/"
SRC_URI="mirror://sourceforge/hugin/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

S=${WORKDIR}/${PN}-"$(get_version_component_range 1-3)"

RDEPEND="!media-gfx/autopano-sift
	dev-libs/libxml2
	media-libs/libpano13:0=
	media-libs/libpng:0=
	media-libs/tiff:0=
	sys-libs/zlib
	virtual/jpeg:0"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-lm.patch
	epatch_user
}
