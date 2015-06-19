# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gpe-utils/gpe-edit/gpe-edit-0.41.ebuild,v 1.6 2009/07/13 23:40:54 miknix Exp $

GPE_TARBALL_SUFFIX="bz2"
inherit gpe autotools

DESCRIPTION="Editor for the GPE Palmtop Environment"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="${IUSE}"
RDEPEND="${RDEPEND}
	gpe-base/libgpewidget"

DEPEND="${DEPEND}
	${RDEPEND}"

GPE_DOCS="ChangeLog"

src_unpack() {
	gpe_src_unpack "$@"

	# Angelo Arrifano <miknix@gentoo.org>: Fix access violation
	sed -i -e 's;mimedir = /etc/;mimedir = ${sysconfdir}/;' Makefile.am \
		|| die "sed failed"
	# fixes test suite, see bug 276829
	echo "gpe-edit.desktop.in" >> po/POTFILES.skip || die
	eautoreconf
}
