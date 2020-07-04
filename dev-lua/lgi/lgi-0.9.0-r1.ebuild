# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VIRTUALX_REQUIRED="manual"

inherit eutils toolchain-funcs flag-o-matic virtualx

DESCRIPTION="Lua bindings using gobject-introspection"
HOMEPAGE="https://github.com/pavouk/lgi"
SRC_URI="https://github.com/pavouk/lgi/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-lang/lua-5.1
		dev-libs/gobject-introspection
		dev-libs/glib
		virtual/libffi:0="
DEPEND="${RDEPEND}
		virtual/pkgconfig
		test? (
			x11-libs/cairo[glib]
			x11-libs/gtk+[introspection]
			${VIRTUALX_DEPEND}
		)"

src_prepare() {
	default

	sed -i \
		-e "s:^LUA_LIBDIR.*$:LUA_LIBDIR = $($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua):" \
		-e "s:^LUA_SHAREDIR.*$:LUA_SHAREDIR = $($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua):" \
		"${S}"/lgi/Makefile || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)" COPTFLAGS="-Wall -Wextra ${CFLAGS}" LIBFLAG="-shared ${LDFLAGS}"
}

src_test() {
	virtx emake CC="$(tc-getCC)" COPTFLAGS="-Wall -Wextra ${CFLAGS}" LIBFLAG="-shared ${LDFLAGS}" check
}

src_install() {
	emake DESTDIR="${D}" install
	docompress -x /usr/share/doc/${PF}
	dodoc README.md
	dodoc -r docs/*
	if use examples; then
		dodoc -r samples
	fi
}
