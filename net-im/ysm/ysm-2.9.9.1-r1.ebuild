# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic versionator

MY_PV="$(replace_all_version_separators _)"

DESCRIPTION="A console ICQ client supporting versions 7/8"
HOMEPAGE="http://ysmv7.sourceforge.net/"
SRC_URI="mirror://sourceforge/ysmv7/${PN}v7_${MY_PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
RESTRICT="mirror"

S=${WORKDIR}/${PN}v7_${MY_PV}

src_prepare() {
	# fix bug 570408 by restoring pre-GCC5 inline semantics
	append-cflags -std=gnu89
	default
}
