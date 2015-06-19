# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gpe-base/libschedule/libschedule-0.17.ebuild,v 1.2 2009/08/26 17:37:53 miknix Exp $

GPE_TARBALL_SUFFIX="bz2"

inherit gpe

DESCRIPTION="RTC alarm handling library for the GPE Palmtop Environment"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
GPE_DOCS="ChangeLog"

IUSE=""
GPECONF="${GPECONF} --disable-gtk-doc"

# This package doesn't generate any gtk-doc yet,
# leave this commented for now.
# IUSE="doc"
# GPECONF="${GPECONF} $(use_enable doc gtk-doc)"
# DEPEND="doc? ( >=dev-util/gtk-doc-1.2 )"

RDEPEND="${RDEPEND}
	gpe-base/libgpewidget
	>=dev-libs/glib-2.6.3"

DEPEND="${DEPEND} ${RDEPEND}
	dev-util/gtk-doc-am"

src_install() {
	gpe_src_install "$@"
	make DESTDIR="${D}" PREFIX=/usr install-devel
}
