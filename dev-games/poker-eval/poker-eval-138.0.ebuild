# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/poker-eval/poker-eval-138.0.ebuild,v 1.5 2015/03/23 07:48:44 mr_bones_ Exp $

EAPI=5
inherit eutils

DESCRIPTION="A fast C library for evaluating poker hands"
HOMEPAGE="http://gna.org/projects/pokersource/"
SRC_URI="http://download.gna.org/pokersource/sources/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

src_configure() {
	econf \
		--without-ccache \
		$(use_enable static-libs static)
}

src_install() {
	DOCS="AUTHORS ChangeLog NEWS README TODO WHATS-HERE" \
		default
	prune_libtool_files
}
