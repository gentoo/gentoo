# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmelf/libmelf-0.4.0.ebuild,v 1.2 2014/08/10 20:36:35 slyfox Exp $

EAPI=3
inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="libmelf is a library interface for manipulating ELF object files"
HOMEPAGE="http://www.hick.org/code/skape/libmelf/"
SRC_URI="http://www.hick.org/code/skape/${PN}/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc-makefile-cleanup.patch
}

src_compile() {
	append-flags -fPIC
	emake CC="$(tc-getCC)" OPTFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	into /usr
	dobin tools/elfres
	dolib.a libmelf.a
	dolib.so libmelf.so
	insinto /usr/include
	doins melf.h stdelf.h
	dodoc ChangeLog README
	dohtml -r docs/html
}
