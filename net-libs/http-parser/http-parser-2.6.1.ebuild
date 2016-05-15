# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs multilib multilib-minimal

DESCRIPTION="Http request/response parser for C"
HOMEPAGE="https://github.com/nodejs/http-parser"
SRC_URI="https://github.com/nodejs/http-parser/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86 ~x64-macos ~x64-solaris"
IUSE="static-libs"

# https://github.com/nodejs/http-parser/pull/272
PATCHES=(
	"${FILESDIR}"/0001-makefile-fix-DESTDIR-usage.patch
	"${FILESDIR}"/0002-makefile-quote-variables.patch
	"${FILESDIR}"/0003-makefile-fix-SONAME-symlink-it-should-not-be-a-full-.patch
	"${FILESDIR}"/0004-makefile-add-CFLAGS-to-linking-command.patch
	"${FILESDIR}"/0005-makefile-fix-install-rule-dependency.patch
)

src_prepare() {
	tc-export CC AR
	epatch ${PATCHES[@]}
	multilib_copy_sources
}

multilib_src_compile() {
	emake CFLAGS_FAST="${CFLAGS}" library
	use static-libs && emake CFLAGS_FAST="${CFLAGS}" package
}

multilib_src_test() {
	emake CFLAGS_DEBUG="${CFLAGS}" test
}

multilib_src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" install
	use static-libs && dolib.a libhttp_parser.a
}
