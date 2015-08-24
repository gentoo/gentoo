# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib git-r3 autotools

DESCRIPTION="Gentoo Linux USE flags editor"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI=""
EGIT_REPO_URI="git://anongit.gentoo.org/proj/ufed.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="sys-libs/ncurses:5="
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
