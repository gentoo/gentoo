# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools

DESCRIPTION="A message sequence chart generator"
HOMEPAGE="http://www.mcternan.me.uk/mscgen/"
SRC_URI="http://www.mcternan.me.uk/${PN}/software/${PN}-src-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86 ~x64-solaris"
IUSE="png truetype"

RDEPEND="png? (	media-libs/gd[png,truetype?] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/bison
	sys-devel/flex"

# Workaround for bug #379279
RESTRICT="test"

src_prepare() {
	sed -i -e '/dist_doc_DATA/d' Makefile.am || die
	eautoreconf
}

src_configure() {
	local myconf

	if use png; then
		use truetype && myconf="--with-freetype"
	else
		myconf="--without-png"
	fi

	econf \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		${myconf}
}
