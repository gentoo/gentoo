# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Open-source library for reading, mastering and writing optical discs"
HOMEPAGE="http://libburnia-project.org/"
SRC_URI="http://files.libburnia-project.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE="acl debug static-libs verbose-debug xattr zlib"

RDEPEND="acl? ( virtual/acl )
	xattr? ( sys-apps/attr )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf \
	$(use_enable static-libs static) \
	$(use_enable debug) \
	$(use_enable verbose-debug) \
	$(use_enable acl libacl) \
	$(use_enable xattr) \
	$(use_enable zlib) \
	--disable-libjte \
	--disable-ldconfig-at-install
}

src_install() {
	default

	dodoc Roadmap doc/{*.txt,Tutorial}

	prune_libtool_files --all
}
