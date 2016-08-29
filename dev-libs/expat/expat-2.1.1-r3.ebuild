# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils libtool multilib toolchain-funcs multilib-minimal

DESCRIPTION="Stream-oriented XML parser library"
HOMEPAGE="http://expat.sourceforge.net/"
SRC_URI="mirror://sourceforge/expat/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~arm-linux ~x86-linux"
IUSE="elibc_FreeBSD examples static-libs unicode"
RDEPEND="abi_x86_32? ( !<=app-emulation/emul-linux-x86-baselibs-20130224-r6
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)] )"

src_prepare() {
	# https://bugs.gentoo.org/show_bug.cgi?id=583268
	epatch "${FILESDIR}"/${P}-CVE-2015-1283-refix.patch
	epatch "${FILESDIR}"/${P}-CVE-2016-0718-v2-2-1.patch
	epatch "${FILESDIR}"/${P}-CVE-2016-0718-regression.patch

	# https://bugs.gentoo.org/show_bug.cgi?id=577928
	epatch "${FILESDIR}"/${P}-CVE-2012-6702-plus-CVE-2016-5300-v1.patch
}

multilib_src_configure() {
	local myconf="$(use_enable static-libs static)"

	mkdir -p "${BUILD_DIR}"{u,w} || die

	ECONF_SOURCE="${S}" econf ${myconf}

	if use unicode; then
		pushd "${BUILD_DIR}"u >/dev/null
		CPPFLAGS="${CPPFLAGS} -DXML_UNICODE" ECONF_SOURCE="${S}" econf ${myconf}
		popd >/dev/null

		pushd "${BUILD_DIR}"w >/dev/null
		CPPFLAGS="${CPPFLAGS} -DXML_UNICODE_WCHAR_T" ECONF_SOURCE="${S}" econf ${myconf}
		popd >/dev/null
	fi
}

multilib_src_compile() {
	emake

	if use unicode; then
		pushd "${BUILD_DIR}"u >/dev/null
		emake buildlib LIBRARY=libexpatu.la
		popd >/dev/null

		pushd "${BUILD_DIR}"w >/dev/null
		emake buildlib LIBRARY=libexpatw.la
		popd >/dev/null
	fi
}

multilib_src_install() {
	emake install DESTDIR="${D}"

	if use unicode; then
		pushd "${BUILD_DIR}"u >/dev/null
		emake installlib DESTDIR="${D}" LIBRARY=libexpatu.la
		popd >/dev/null

		pushd "${BUILD_DIR}"w >/dev/null
		emake installlib DESTDIR="${D}" LIBRARY=libexpatw.la
		popd >/dev/null

		pushd "${ED}"/usr/$(get_libdir)/pkgconfig >/dev/null
		cp expat.pc expatu.pc
		sed -i -e '/^Libs/s:-lexpat:&u:' expatu.pc || die
		cp expat.pc expatw.pc
		sed -i -e '/^Libs/s:-lexpat:&w:' expatw.pc || die
		popd >/dev/null
	fi

	if multilib_is_native_abi ; then
		# libgeom in /lib and ifconfig in /sbin require libexpat on FreeBSD since
		# we stripped the libbsdxml copy starting from freebsd-lib-8.2-r1
		use elibc_FreeBSD && gen_usr_ldscript -a expat
	fi
}

multilib_src_install_all() {
	dodoc Changes README
	dohtml doc/*

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.c
	fi

	prune_libtool_files
}
