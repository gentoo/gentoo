# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kio-slp/kio-slp-0_p20120621.ebuild,v 1.2 2014/03/20 22:15:48 johu Exp $

EAPI=5

OPENGL_REQUIRED="optional"
inherit kde4-base

DESCRIPTION="Service Location Protocol component for KIO"
HOMEPAGE="http://websvn.kde.org/trunk/playground/network/kio_slp/"
SRC_URI="http://dev.gentoo.org/~creffett/${P}.tar.xz"

LICENSE="GPL-1"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="net-libs/openslp"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}
