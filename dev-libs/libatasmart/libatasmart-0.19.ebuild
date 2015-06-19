# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libatasmart/libatasmart-0.19.ebuild,v 1.9 2012/11/28 18:00:54 ssuominen Exp $

EAPI=5
inherit eutils

DESCRIPTION="A small and lightweight parser library for ATA S.M.A.R.T. hard disks"
HOMEPAGE="http://0pointer.de/blog/projects/being-smart.html"
SRC_URI="http://0pointer.de/public/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86"
IUSE="static-libs"

RDEPEND="virtual/udev"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="README"

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files --all
}
