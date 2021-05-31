# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( luajit )

inherit bash-completion-r1 lua-single toolchain-funcs

DESCRIPTION="Function (graph) tracer for user-space"
HOMEPAGE="https://github.com/namhyung/uftrace"
SRC_URI="https://github.com/namhyung/uftrace/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="bash-completion capstone lua"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"

RESTRICT="test"

RDEPEND="
	sys-libs/ncurses:=
	virtual/libelf:=
	capstone? ( dev-libs/capstone:0= )
	lua? ( ${LUA_DEPS} )
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i -e "s/ARCH/MYARCH/g" -e "/ldconfig/d" -e "/bash.completion/d" Makefile || die
}

src_configure() {
	local myconf=(
		--libdir="${EPREFIX}"/usr/$(get_libdir)/uftrace
		$(use_with capstone)
		--without-libpython
	)
	if use lua && use lua_single_target_luajit; then
		myconf+=(
			--with-libluajit
		)
	else
		myconf+=(
			--without-libluajit
		)
	fi
	CC=$(tc-getCC) LD=$(tc-getLD) econf "${myconf[@]}"
}

src_compile() {
	emake V=1
}

src_install() {
	default
	dodoc doc/*.{md,gif,png}
	use bash-completion && newbashcomp misc/bash-completion.sh uftrace
}
