# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libquvi-scripts/libquvi-scripts-0.4.21-r2.ebuild,v 1.9 2015/05/30 00:03:47 jmorgan Exp $

EAPI=5

inherit multilib-minimal

DESCRIPTION="Embedded lua scripts for libquvi"
HOMEPAGE="http://quvi.sourceforge.net/"
SRC_URI="mirror://sourceforge/quvi/${PV:0:3}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0.4"
KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE="offensive"

DEPEND="app-arch/xz-utils"
RDEPEND="!=media-libs/libquvi-scripts-0.4*:0"

# tests fetch data from live websites, so it's rather normal that they
# will fail
RESTRICT="test"

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		--without-manual \
		$(use_with offensive nsfw)
}
