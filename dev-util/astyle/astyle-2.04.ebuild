# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/astyle/astyle-2.04.ebuild,v 1.1 2014/05/28 23:58:15 jer Exp $

EAPI=5

inherit eutils java-pkg-opt-2 multilib toolchain-funcs

DESCRIPTION="Artistic Style is a reindenter and reformatter of C++, C and Java source code"
HOMEPAGE="http://astyle.sourceforge.net/"
SRC_URI="mirror://sourceforge/astyle/astyle_${PV}_linux.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

IUSE="doc java static-libs"

DEPEND="app-arch/xz-utils
	java? ( >=virtual/jdk-1.6 )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

pkg_setup() {
	java-pkg-opt-2_pkg_setup
	tc-export CXX
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.02.1-build_system.patch
	java-pkg-opt-2_src_prepare
	sed	-e "s:^\(JAVAINCS\s*\)=.*$:\1= $(java-pkg_get-jni-cflags):" \
		-e "s:ar crs:$(tc-getAR) crs:" \
		-i build/gcc/Makefile || die
}

src_compile() {
	emake -f ../build/gcc/Makefile -C src \
		${PN} \
		shared \
		$(usex java java '') \
		$(usex static-libs static '')
}

src_install() {
	insinto /usr/include
	doins src/${PN}.h

	pushd src/bin &> /dev/null
	dobin ${PN}

	dolib.so lib${PN}.so.0.0.0
	dosym lib${PN}.so.0.0.0 /usr/$(get_libdir)/lib${PN}.so.0
	dosym lib${PN}.so.0.0.0 /usr/$(get_libdir)/lib${PN}.so
	if use java ; then
		dolib.so lib${PN}j.so.0.0.0
		dosym lib${PN}j.so.0.0.0 /usr/$(get_libdir)/lib${PN}j.so.0
		dosym lib${PN}j.so.0.0.0 /usr/$(get_libdir)/lib${PN}j.so
	fi
	if use static-libs ; then
		dolib lib${PN}.a
	fi
	popd &> /dev/null

	use doc && dohtml doc/*
}
