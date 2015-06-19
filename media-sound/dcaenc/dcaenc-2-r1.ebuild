# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/dcaenc/dcaenc-2-r1.ebuild,v 1.1 2014/09/03 11:53:02 ssuominen Exp $

EAPI=5

if [[ ${PV} == 9999* ]]; then
AUTOTOOLS_AUTORECONF=1
EGIT_REPO_URI="git://gitorious.org/dtsenc/dtsenc.git"
else
SRC_URI="http://aepatrakov.narod.ru/olderfiles/1/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
fi

inherit autotools autotools-multilib

[[ ${PV} == 9999* ]] && inherit git-r3

DESCRIPTION="DTS Coherent Acoustics audio encoder"
HOMEPAGE="http://aepatrakov.narod.ru/index/0-2"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="alsa"

RDEPEND="alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
