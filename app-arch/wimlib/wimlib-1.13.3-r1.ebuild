# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools pax-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://wimlib.net/${PN}"
else
	MY_PV="${PV/_/-}"
	MY_PV="${MY_PV^^}"
	SRC_URI="https://wimlib.net/downloads/${PN}-${MY_PV}.tar.gz"
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="The open source Windows Imaging (WIM) library"
HOMEPAGE="https://wimlib.net/"

LICENSE="|| ( GPL-3+ LGPL-3+ ) CC0-1.0"
SLOT="0"
IUSE="cpu_flags_x86_ssse3 fuse iso ntfs openssl test threads yasm"
REQUIRED_USE="cpu_flags_x86_ssse3? ( !openssl )"

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
	ntfs? ( sys-fs/ntfs3g:= )
	fuse? ( sys-fs/fuse:0 )
	openssl? ( dev-libs/openssl:= )
	iso? (
		app-arch/cabextract
		app-cdr/cdrtools
	)
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with ntfs ntfs-3g)
		$(use_with fuse)
		$(use_enable cpu_flags_x86_ssse3 ssse3-sha1)
		$(use_with openssl libcrypto)
		$(use_enable threads multithreaded-compression)
		$(use_enable test test-support)
		--disable-static
	)
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
