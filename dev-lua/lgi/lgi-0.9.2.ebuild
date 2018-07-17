# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VIRTUALX_REQUIRED="manual"

inherit eutils toolchain-funcs flag-o-matic virtualx
# inherit eutils toolchain-funcs virtualx

DESCRIPTION="Lua bindings using gobject-introspection"
HOMEPAGE="https://github.com/pavouk/lgi"
SRC_URI="https://github.com/pavouk/lgi/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86 ~x86-fbsd"
IUSE="examples test"
PATCHES="${FILESDIR}/${P}.patch"

RDEPEND="dev-lang/lua:*
		dev-libs/gobject-introspection
		dev-libs/glib
		virtual/libffi"
DEPEND="${RDEPEND}
		virtual/pkgconfig
		test? (
			x11-libs/cairo[glib]
			x11-libs/gtk+[introspection]
			${VIRTUALX_DEPEND}
		)"

src_prepare() {
	default_src_prepare
	eapply_user
}

src_compile() {
	emake CC="$(tc-getCC)" COPTFLAGS="-Wall -Wextra ${CFLAGS}" LIBFLAG="-shared ${LDFLAGS}"
}

src_test() {
	virtx emake CC="$(tc-getCC)" COPTFLAGS="-Wall -Wextra ${CFLAGS}" LIBFLAG="-shared ${LDFLAGS}" check
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc -r docs/*
	dodoc README.md
	if use examples; then
		dodoc -r samples
	fi
}
