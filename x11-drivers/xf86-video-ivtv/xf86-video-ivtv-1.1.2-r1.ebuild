# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-ivtv/xf86-video-ivtv-1.1.2-r1.ebuild,v 1.4 2013/08/27 12:22:47 chithanh Exp $

EAPI=4
inherit xorg-2

DESCRIPTION="X.Org driver for TV-out on ivtvdev cards"
HOMEPAGE="http://ivtvdriver.org/"
SRC_URI="http://dl.ivtvdriver.org/${PN}/${P}.tar.gz \
	mirror://gentoo/${PF}.patch.tar.bz2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="<x11-base/xorg-server-1.12.49"
RDEPEND="${DEPEND}"

src_prepare() {

	EPATCH_SOURCE="${WORKDIR}" \
	EPATCH_FORCE="yes" \
	EPATCH_SUFFIX="patch" \
	xorg-2_src_prepare
}
