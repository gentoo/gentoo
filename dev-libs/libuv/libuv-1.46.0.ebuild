# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Cross-platform asychronous I/O"
HOMEPAGE="https://github.com/libuv/libuv"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/libuv/libuv.git"
	inherit git-r3
else
	SRC_URI="https://github.com/libuv/libuv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 -hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

LICENSE="BSD BSD-2 ISC MIT"
SLOT="0/1"

BDEPEND="
	sys-devel/libtool
	virtual/pkgconfig
"

src_prepare() {
	default

	echo "m4_define([UV_EXTRA_AUTOMAKE_FLAGS], [serial-tests])" \
		> m4/libuv-extra-automake-flags.m4 || die

	if [[ ${CHOST} == *-darwin* && ${CHOST##*darwin} -le 9 ]] ; then
		eapply "${FILESDIR}"/${PN}-1.41.0-darwin.patch
	fi

	# Upstream fails to ship a configure script
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		cc_cv_cflags__g=no
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
