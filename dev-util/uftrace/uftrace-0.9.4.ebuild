# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1

DESCRIPTION="Function (graph) tracer for user-space"
HOMEPAGE="https://github.com/namhyung/uftrace"
SRC_URI="https://github.com/namhyung/uftrace/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="bash-completion capstone luajit"

RESTRICT="test"

RDEPEND="
	sys-libs/ncurses:=
	virtual/libelf:=
	capstone? ( dev-libs/capstone:0= )
	luajit? ( dev-lang/luajit )
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i -e "s/ARCH/MYARCH/g" -e "/ldconfig/d" -e "/bash.completion/d" Makefile || die
}

src_configure() {
	econf \
		$(use_with capstone) \
		$(use_with luajit libluajit) \
		--without-libpython
}

src_install() {
	default
	dodoc doc/*.{md,gif,png}
	use bash-completion && newbashcomp misc/bash-completion.sh uftrace
}
