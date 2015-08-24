# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OPENGL_REQUIRED="optional"
inherit kde4-base

DESCRIPTION="Service Location Protocol component for KIO"
HOMEPAGE="https://websvn.kde.org/trunk/playground/network/kio_slp/"
SRC_URI="https://dev.gentoo.org/~creffett/${P}.tar.xz"

LICENSE="GPL-1"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="net-libs/openslp"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}
