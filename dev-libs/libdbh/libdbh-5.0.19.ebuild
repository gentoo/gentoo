# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

MY_P=${PN}2-${PV}

DESCRIPTION="a small library to create and manage 64-bit disk based hash tables"
HOMEPAGE="https://www.gnu.org/software/libdbh/"
SRC_URI="mirror://sourceforge/dbh/dbh/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig"

S="${WORKDIR}"/${MY_P}

pkg_setup() {
	DOCS=( AUTHORS ChangeLog NEWS README TODO )
}

src_prepare() {
	sed -i -e "s:-O2:${CFLAGS}:" m4/rfm-conditionals.m4 || die
	eautoreconf
}

src_install() {
	default
	prune_libtool_files
}
