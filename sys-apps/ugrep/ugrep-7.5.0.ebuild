# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A more powerful, ultra fast, user-friendly, compatible grep"
HOMEPAGE="https://ugrep.com/"
SRC_URI="https://github.com/Genivia/ugrep/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cpu_flags_arm_neon cpu_flags_x86_avx2 cpu_flags_x86_sse2 brotli bzip3 +pcre"

# Technically all are configure opts, but for standard compression formats
# I'm not sure we need a billion USE flags.
# pcre is not slotted since slot is for -lpcre2-posix which we don't need.
DEPEND="
	app-arch/bzip2:=
	app-arch/lz4:=
	app-arch/xz-utils:=
	app-arch/zstd:=
	sys-libs/zlib:=
	brotli? ( app-arch/brotli:= )
	bzip3? ( app-arch/bzip3:= )
	pcre? ( dev-libs/libpcre2 )

"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local myeconfargs=(
		$(use_enable cpu_flags_arm_neon neon)
		$(use_enable cpu_flags_x86_avx2 avx2)
		$(use_enable cpu_flags_x86_sse2 sse2)
		$(use_with brotli)
		$(use_with bzip3)
		$(use_with pcre pcre2)
		# completely broken
		--without-boost-regex
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	# https://github.com/Genivia/ugrep/pull/515
	emake test
}
