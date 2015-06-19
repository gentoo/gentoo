# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gpe-base/libgpevtype/libgpevtype-0.50.ebuild,v 1.5 2009/08/26 16:32:25 miknix Exp $

GPE_TARBALL_SUFFIX="bz2"
inherit gpe autotools

DESCRIPTION="Data interchange library for the GPE Palmtop Environment"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
IUSE="doc"
GPE_DOCS="ChangeLog"
GPECONF="${GPECONF} $(use_enable doc gtk-doc)"

RDEPEND="${RDEPEND}
	gpe-base/libtododb
	>=dev-libs/glib-2.2
	>=gpe-base/libmimedir-0.4.2
	>=gpe-base/libeventdb-0.29"

DEPEND="${DEPEND}
	${RDEPEND}
	doc? ( >=dev-util/gtk-doc-1.2 )
	dev-util/gtk-doc-am"

src_unpack() {
	gpe_src_unpack "$@"

	if ! use doc; then
		sed -i -e 's;SUBDIRS = doc;SUBDIRS = ;' Makefile.am \
		|| die "sed failed"
	fi

	eautoreconf
}
