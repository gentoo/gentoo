# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Abstracts the storage of configuration settings away from applications"
HOMEPAGE="http://git.atheme.org/libmcs/"
SRC_URI="http://distfiles.atheme.org/${P}.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux"
IUSE="gnome"

RDEPEND=">=dev-libs/libmowgli-0.6.1:0
	gnome? ( >=gnome-base/gconf-2.6.0 )"
DEPEND="virtual/pkgconfig
	${RDEPEND}"
DOCS="AUTHORS README TODO"

src_configure() {
	econf \
		--disable-kconfig \
		$(use_enable gnome gconf)
}
