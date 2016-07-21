# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

GPE_TARBALL_SUFFIX="bz2"

inherit gpe autotools

DESCRIPTION="XSETTINGS client code"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ppc sh x86"

DOCS="ChangeLog"
IUSE=""

RDEPEND="${RDEPEND}"

DEPEND="${DEPEND}
	${RDEPEND}
	x11-proto/xproto
	x11-libs/libX11"

src_unpack() {
	gpe_src_unpack "$@"

	sed -i -e \
		's;INCLUDES = -I $(includedir);INCLUDES = -I '$ROOT'/$(includedir);' \
		Makefile.am || die "sed failed"
	sed -i -e '/^CFLAGS="-Os -Wall"/d' configure.ac || die "sed failed"
	eautoreconf
}
