# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gpe-utils/gpe-ownerinfo/gpe-ownerinfo-0.28.ebuild,v 1.2 2009/03/14 23:27:57 mr_bones_ Exp $

inherit gpe

DESCRIPTION="GPE owner information dialog"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"

RDEPEND="${RDEPEND}
	>=gpe-base/libgpewidget-0.117"

DEPEND="${DEPEND}
	${RDEPEND}"

IUSE=""

GPE_DOCS="README ChangeLog"

src_install() {
	gpe_src_install install-devel
}
