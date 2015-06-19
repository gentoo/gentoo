# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/ucpp/ucpp-9999.ebuild,v 1.2 2012/11/21 16:37:12 scarabeus Exp $

EAPI=5

EGIT_REPO_URI="git://github.com/scarabeusiv/ucpp.git"
inherit eutils git-2 autotools

DESCRIPTION="A quick and light preprocessor, but anyway fully compliant to C99"
HOMEPAGE="http://code.google.com/p/ucpp/"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--disable-werror \
		$(use_enable static-libs static)
}

src_install() {
	default

	prune_libtool_files --all
}
