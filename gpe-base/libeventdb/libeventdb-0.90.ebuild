# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gpe-base/libeventdb/libeventdb-0.90.ebuild,v 1.8 2010/05/26 14:38:02 miknix Exp $

GPE_TARBALL_SUFFIX="bz2"

inherit gpe eutils autotools

DESCRIPTION="Database access library for GPE calendar"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
IUSE="doc"
GPE_DOCS="ChangeLog"
GPECONF="${GPECONF} $(use_enable doc gtk-doc)"

RDEPEND="${RDEPEND}
	>=gpe-base/libgpewidget-0.113
	>=gpe-base/libgpepimc-0.6
	=dev-db/sqlite-2.8*"

DEPEND="${DEPEND}
	${RDEPEND}
	doc? ( >=dev-util/gtk-doc-1.2 )
	dev-util/gtk-doc-am"

src_unpack() {
	gpe_src_unpack "$@"

	epatch "${FILESDIR}"/libeventdb-unbreak-LIVE-macro.patch

	# Wrong linker logic, fixes bug #320035 .
	epatch "${FILESDIR}"/${P}-doclinkerfix.patch

	if ! use doc; then
		sed -i -e 's;SUBDIRS = doc;SUBDIRS = ;' Makefile.am \
		|| die "sed failed"
	fi

	eautoreconf
}
