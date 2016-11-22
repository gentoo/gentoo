# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Hybrid between a make utility and a shell scripting language"
HOMEPAGE="https://fbb-git.github.io/icmake/ https://github.com/fbb-git/icmake"
SRC_URI="https://github.com/fbb-git/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/${P}/${PN}

src_prepare() {
	local PATCHES=( "${FILESDIR}"/${P}-ar.patch )

	sed -e "/^#define LIBDIR/s/lib/$(get_libdir)/" \
		-e "/^#define DOCDIR/s/${PN}/${PF}/" \
		-e "/^#define DOCDOCDIR/s/${PN}-doc/${PF}/" \
		-i INSTALL.im || die

	tc-export AR CC

	default
}

src_configure() {
	./icm_prepare "${EROOT}" || die
}

src_compile() {
	./icm_bootstrap "${EROOT}" || die
}

src_install() {
	./icm_install all "${ED}" || die
}
