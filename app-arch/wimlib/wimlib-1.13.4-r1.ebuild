# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools pax-utils

DESCRIPTION="The open source Windows Imaging (WIM) library"
HOMEPAGE="https://wimlib.net"
SRC_URI="https://wimlib.net/downloads/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="|| ( GPL-3+ LGPL-3+ ) CC0-1.0"
SLOT="0"
IUSE="cpu_flags_x86_ssse3 fuse iso ntfs ssl test threads yasm"

RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	cpu_flags_x86_ssse3? (
		yasm? ( dev-lang/yasm )
		!yasm? ( dev-lang/nasm )
	)
"
RDEPEND="
	dev-libs/libxml2:2
	fuse? ( sys-fs/fuse:0 )
	iso? (
		app-arch/cabextract
		app-cdr/cdrtools
	)
	ntfs? ( sys-fs/ntfs3g:= )
	ssl? ( dev-libs/openssl:= )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with ntfs ntfs-3g)
		$(use_with fuse)
		$(use_with ssl libcrypto)
		$(use_enable threads multithreaded-compression)
		$(use_enable test test-support)
		--disable-static
	)

	if use cpu_flags_x86_ssse3; then
		if ! use ssl; then
			myeconfargs+=( --enable-ssse3-sha1 )
		else
			elog "cpu_flags_x86_ssse3 and ssl can't be enabled together, "
			elog "enabling ssl and disabling cpu_flags_x86_ssse3 for you."
			myeconfargs+=( --disable-ssse3-sha1 )
		fi
	fi

	ac_cv_prog_NASM="$(usex yasm yasm nasm)" \
		econf "${myeconfargs[@]}"
}

src_compile() {
	default
	pax-mark m "${S}"/.libs/wimlib-imagex
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
