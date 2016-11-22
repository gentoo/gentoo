# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit toolchain-funcs multilib-minimal

DESCRIPTION="Low-overhead managed string library for C"
HOMEPAGE="http://www.and.org/ustr"
SRC_URI="ftp://ftp.and.org/pub/james/ustr/${PV}/${P}.tar.bz2"

LICENSE="|| ( BSD-2 MIT LGPL-2 )"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~mips x86"
IUSE="static-libs ustr-import"

DOCS=(ChangeLog README README-DEVELOPERS AUTHORS NEWS TODO)

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/ustr-conf.h
	/usr/include/ustr-conf-debug.h
)

src_prepare() {
	epatch "${FILESDIR}/${P}-gcc_5-check.patch"
	epatch "${FILESDIR}/${PN}-1.0.4-build-libs.patch"
	multilib_copy_sources
}

_emake() {
	emake \
		USE_STATIC=$(usex static-libs) \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} ${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		prefix="${EPREFIX}/usr" \
		libdir="${EPREFIX}/usr/$(get_libdir)" \
		mandir="${EPREFIX}/usr/share/man" \
		SHRDIR="${EPREFIX}/usr/share/${P}" \
		DOCSHRDIR="${EPREFIX}/usr/share/doc/${PF}" \
		HIDE= \
		"$@"
}

multilib_src_configure() {
	# The included configure tests require execution.

	# We require vsnprintf everywhere as it's in POSIX.
	printf '#!/bin/sh\necho 0\n' > autoconf_vsnprintf
	chmod a+rx autoconf_vsnprintf

	# Always use stdint.h as it's in POSIX.
	sed -i '/have_stdint_h=0/s:=0:=1:' Makefile || die

	# Figure out the size of size_t.
	printf '#include <sys/types.h>\nint main() { char buf[sizeof(size_t) - 8]; }\n' > sizet_test.c
	 $(tc-getCC) ${CPPFLAGS} ${CFLAGS} -c sizet_test.c 2>/dev/null
	printf '#!/bin/sh\necho %s\n' $(( $? == 0 )) > autoconf_64b
	chmod a+rx autoconf_64b

	# Generate the config file now to avoid bad makefile deps.
	_emake ustr-import
}

multilib_src_compile() {
	_emake all-shared
}

multilib_src_install() {
	_emake DESTDIR="${D}" install

	if ! use ustr-import ; then
		rm -r \
			"${ED}/usr/bin/ustr-import" \
			"${ED}/usr/share/man/man1/ustr-import.1" \
			"${ED}/usr/share/${P}" || die
	fi
}

multilib_src_test() {
	_emake check
}
