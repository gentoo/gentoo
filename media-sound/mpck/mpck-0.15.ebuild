# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=checkmate-${PV}

DESCRIPTION="Checks MP3s for errors"
HOMEPAGE="http://mpck.linuxonly.nl/"
SRC_URI="http://checkmate.linuxonly.nl/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

S="${WORKDIR}/${MY_P}"

DOCS=( ABOUT_FIXING AUTHORS ChangeLog HISTORY NEWS README TODO )
