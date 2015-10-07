# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

MY_P=${PN}0-${PV}

DESCRIPTION="small and simple interprocess communication library"
HOMEPAGE="http://xffm.org/libtubo"
SRC_URI="mirror://sourceforge/xffm/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}"/${MY_P}

pkg_setup() {
	DOCS=( AUTHORS ChangeLog NEWS README TODO )
}

src_install() {
	default
	prune_libtool_files
}
