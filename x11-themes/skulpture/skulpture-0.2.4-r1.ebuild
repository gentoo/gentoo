# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/skulpture/skulpture-0.2.4-r1.ebuild,v 1.3 2014/04/28 22:34:32 johu Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="Classical style and window decorations for KDE"
HOMEPAGE="http://skulpture.maxiom.de/"
SRC_URI="http://kde-look.org/CONTENT/content-files/59031-${P}.tar.gz"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="$(add_kdebase_dep kwin)"
RDEPEND="${DEPEND}"
