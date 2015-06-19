# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/xmlwrapp/xmlwrapp-0.5.0-r1.ebuild,v 1.24 2013/12/02 08:54:04 pinkbyte Exp $

inherit eutils multilib toolchain-funcs

DESCRIPTION="modern style C++ library that provides a simple and easy interface to libxml2"
HOMEPAGE="http://sourceforge.net/projects/xmlwrapp/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~mips ppc ~ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="doc test"

RDEPEND="dev-libs/libxml2
	dev-libs/libxslt"
DEPEND="${RDEPEND}
	dev-lang/perl"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-gentoo.diff" \
		"${FILESDIR}/${P}-tests.patch" \
		"${FILESDIR}/${P}-fbsd.patch" \
		"${FILESDIR}/${P}-gcc42_namespace.patch" \
		"${FILESDIR}/${P}-gcc-4.3.patch"

	sed -i 's/-O2//' tools/cxxflags || die "sed tools/cxxflags failed"
}

src_compile() {
	local myconf="--prefix /usr --libdir /usr/$(get_libdir) --disable-examples"
	use test && myconf="${myconf} --enable-tests"

	export CXX="$(tc-getCXX)"
	./configure.pl ${myconf} || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	sed -i "s%/usr%${D}/usr%g" Makefile || die "sed Makefile failed"
	emake install || die "emake install failed"

	dodoc README docs/{CREDITS,TODO,VERSION}
	if use doc ; then
		dohtml "${S}"/docs/doxygen/html/*
		cd examples
		for ex in 0* ; do
			docinto examples/${ex}
			dodoc ${ex}/*
		done
	fi
}
