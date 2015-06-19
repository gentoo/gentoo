# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libatomic_ops/libatomic_ops-7.2d.ebuild,v 1.14 2013/02/28 13:39:40 jer Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Implementation for atomic memory update operations"
HOMEPAGE="http://www.hpl.hp.com/research/linux/atomic_ops/"
SRC_URI="http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/gc-${PV/_}.tar.gz"

LICENSE="MIT boehm-gc GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

S=${WORKDIR}/gc-${PV/d}/libatomic_ops

src_prepare() {
	sed -i \
		-e "/^pkgdatadir/s:/.*:/doc/${PF}:" \
		doc/Makefile.in || die
	find -type f -exec touch -r . {} +
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default
	find "${ED}" '(' -name COPYING -o -name LICENSING.txt ')' -delete
}
