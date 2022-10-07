# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=checkmate-${PV}

DESCRIPTION="Checks MP3s for errors"
HOMEPAGE="http://mpck.linuxonly.nl/"
SRC_URI="http://checkmate.linuxonly.nl/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

DOCS=( ABOUT_FIXING AUTHORS ChangeLog HISTORY NEWS README TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-0.15-implicit-func-decl.patch
)
