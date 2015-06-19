# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gpe-utils/gpe-what/gpe-what-0.43.ebuild,v 1.3 2014/08/10 21:17:41 slyfox Exp $

GPE_TARBALL_SUFFIX="bz2"
GPE_MIRROR="http://gpe.linuxtogo.org/download/source"
inherit eutils gpe

DESCRIPTION="The GPE interactive help"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
IUSE=""
DEPEND="${DEPEND}
	gpe-base/libgpewidget"
RDEPEND="${RDEPEND}
	${DEPEND}"
