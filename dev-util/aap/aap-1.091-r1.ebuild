# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/aap/aap-1.091-r1.ebuild,v 1.1 2012/12/05 06:02:22 ottxor Exp $

EAPI=4

IUSE="doc"

DESCRIPTION="Bram Moolenaar's super-make program"
HOMEPAGE="http://www.a-a-p.org/"
SRC_URI="mirror://sourceforge/a-a-p/${P}.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~mips ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
DEPEND="app-arch/unzip"
RDEPEND="dev-lang/python"
S=${WORKDIR}

src_install() {
	rm doc/*.sgml doc/*.pdf || die
	use doc && dohtml -r doc/*.html doc/images
	rm -r doc/*.html doc/images || die

	dodoc doc/*
	doman aap.1
	rm -r doc aap.1 || die

	# Move the remainder directly into the dest tree
	dodir /usr/share/aap
	cp -R * "${ED}"/usr/share/aap || die

	# Create a symbolic link for the executable
	dosym ../share/aap/aap /usr/bin/aap
}
