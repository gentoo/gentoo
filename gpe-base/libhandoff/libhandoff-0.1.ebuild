# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gpe-base/libhandoff/libhandoff-0.1.ebuild,v 1.3 2009/08/26 17:52:55 miknix Exp $

GPE_TARBALL_SUFFIX="bz2"
GPE_MIRROR="http://gpe.linuxtogo.org/download/source"
inherit eutils gpe

DESCRIPTION="Handoff implementation for the GPE Palmtop Environment"

LICENSE="GPL-2"
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
	>=gpe-base/libgpewidget-0.102"
DEPEND="${DEPEND} ${RDEPEND}
	dev-util/gtk-doc-am"
