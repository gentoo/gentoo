# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils scons-utils toolchain-funcs

DESCRIPTION="HTTP client library"
HOMEPAGE="https://code.google.com/p/serf/"
SRC_URI="https://serf.googlecode.com/svn/src_releases/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="kerberos"

RDEPEND="dev-libs/apr:1=
	dev-libs/apr-util:1=
	dev-libs/openssl:0=
	sys-libs/zlib:0=
	kerberos? ( virtual/krb5 )"
DEPEND="${RDEPEND}
	>=dev-util/scons-2.3.0"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.3.2-disable_linking_against_unneeded_libraries.patch"
	epatch "${FILESDIR}/${PN}-1.3.8-scons_variables.patch"
	epatch "${FILESDIR}/${PN}-1.3.8-tests.patch"

	# https://code.google.com/p/serf/issues/detail?id=133
	sed -e "/env.Append(CCFLAGS=\['-O2'\])/d" -i SConstruct
}

src_compile() {
	local myesconsargs=(
		PREFIX="${EPREFIX}/usr"
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		APR="${EPREFIX}/usr/bin/apr-1-config"
		APU="${EPREFIX}/usr/bin/apu-1-config"
		OPENSSL="${EPREFIX}/usr"
		CC="$(tc-getCC)"
		CPPFLAGS="${CPPFLAGS}"
		CFLAGS="${CFLAGS}"
		LINKFLAGS="${LDFLAGS}"
	)

	if use kerberos; then
		myesconsargs+=(GSSAPI="${EPREFIX}/usr/bin/krb5-config")
	fi

	escons
}

src_test() {
	escons check
}

src_install() {
	escons install --install-sandbox="${D}"
}
