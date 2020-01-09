# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit multilib eutils toolchain-funcs usr-ldscript

DESCRIPTION="reiser4progs: mkfs, fsck, etc..."
HOMEPAGE="https://sourceforge.net/projects/reiser4/"
SRC_URI="mirror://sourceforge/reiser4/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 -sparc x86"
IUSE="debug readline static static-libs"

LIB_DEPEND=">=sys-libs/libaal-1.0.6:=[static-libs(+)]
	readline? ( sys-libs/readline:0=[static-libs(+)] )"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	static-libs? ( >=sys-libs/libaal-1.0.6:=[static-libs(+)] )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )"

PATCHES=( "${FILESDIR}"/${PN}-1.0.7-readline-6.3.patch )

src_prepare() {
	printf '#!/bin/sh\ntrue\n' > run-ldconfig
	# Delete hardcoded link/compile flags.
	sed -i -r \
		-e '/CFLAGS=/s: -static":":' \
		-e '/CFLAGS/s: (-O[123s]|-g)\>::g' \
		configure || die

	default
}

src_configure() {
	local myeconfargs=(
		$(use_enable static full-static)
		$(use_enable static-libs static)
		$(use_enable debug)
		$(use_with readline)
		--disable-Werror
		--enable-libminimal
		--sbindir=/sbin
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	gen_usr_ldscript -a reiser4{,-minimal} repair
}
