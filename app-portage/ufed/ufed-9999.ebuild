# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/ufed/ufed-9999.ebuild,v 1.5 2015/04/25 16:25:44 floppym Exp $

EAPI=4

inherit eutils multilib git-2 autotools

EGIT_REPO_URI="git://anongit.gentoo.org/proj/ufed.git"

DESCRIPTION="Gentoo Linux USE flags editor"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="sys-libs/ncurses"
RDEPEND="${COMMON_DEPEND}
	dev-lang/perl"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

src_prepare() {
	# Change the version number to reflect the ebuild version
	sed -i "s:,\[git\],:,\[9999-${EGIT_VERSION}\],:" configure.ac
	eautoreconf
}

src_configure() {
	econf --libexecdir="${EPREFIX}"/usr/$(get_libdir)/ufed
}
