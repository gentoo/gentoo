# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/waheela/waheela-0.3.ebuild,v 1.3 2014/03/21 19:56:06 johu Exp $

EAPI=5

inherit kde4-base

MY_P=${P/-/_}

DESCRIPTION="Amarok Fullscreen Player"
HOMEPAGE="http://kde-apps.org/content/show.php?content=108863"
SRC_URI="http://linux.wuertz.org/dists/sid/main/source/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="media-sound/amarok:4"

S=${WORKDIR}/${PN}
