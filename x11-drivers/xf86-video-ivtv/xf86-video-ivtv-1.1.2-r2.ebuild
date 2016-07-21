# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit xorg-2

DESCRIPTION="X.Org driver for TV-out on ivtvdev cards"
HOMEPAGE="http://ivtvdriver.org/"
SRC_URI="http://dl.ivtvdriver.org/${PN}/${P}.tar.gz \
	mirror://gentoo/${PF}.patch.tar.bz2"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_prepare() {

	EPATCH_SOURCE="${WORKDIR}" \
	EPATCH_FORCE="yes" \
	EPATCH_SUFFIX="patch" \
	xorg-2_src_prepare
}
