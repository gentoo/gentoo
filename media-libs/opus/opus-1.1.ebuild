# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/opus/opus-1.1.ebuild,v 1.12 2015/07/03 10:12:04 ago Exp $

EAPI=5
AUTOTOOLS_AUTORECONF="1"
inherit autotools-multilib

if [[ ${PV} == *9999 ]] ; then
	inherit git-2
	EGIT_REPO_URI="git://git.opus-codec.org/opus.git"
else
	SRC_URI="http://downloads.xiph.org/releases/${PN}/${P}.tar.gz"
	KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd"
fi

DESCRIPTION="Open versatile codec designed for interactive speech and audio transmission over the internet"
HOMEPAGE="http://opus-codec.org/"
SRC_URI="http://downloads.xiph.org/releases/opus/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
IUSE="custom-modes doc static-libs"

DEPEND="doc? ( app-doc/doxygen )"

PATCHES=( "${FILESDIR}/1.1-fix-configure.ac-shell-bug.patch" ) # bug 510918

src_configure() {
	local myeconfargs=(
		$(use_enable custom-modes)
		$(use_enable doc)
	)
	autotools-multilib_src_configure
}
