# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

DESCRIPTION="High-performance C development framework. Can be used stand-alone or as a supplement to GLib"
HOMEPAGE="http://www.atheme.org/project/mowgli"
SRC_URI="http://distfiles.atheme.org/${P}.tar.bz2"
IUSE=""

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS README doc/BOOST
}
