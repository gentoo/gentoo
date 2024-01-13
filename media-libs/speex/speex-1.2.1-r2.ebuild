# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic multilib-minimal

MY_P=${P/_}
MY_P=${MY_P/_p/.}

DESCRIPTION="Audio compression format designed for speech"
HOMEPAGE="https://www.speex.org/"
SRC_URI="https://downloads.xiph.org/releases/speex/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="cpu_flags_arm_v4 cpu_flags_arm_v5 cpu_flags_arm_v6 cpu_flags_x86_sse utils valgrind +vbr"

RDEPEND="
	utils? (
		media-libs/libogg:=
		media-libs/speexdsp[${MULTILIB_USEDEP}]
	)"
DEPEND="
	${RDEPEND}
	valgrind? ( dev-debug/valgrind )
"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.0-configure.patch
	"${FILESDIR}"/${P}-vla-detection.patch
	"${FILESDIR}"/${PN}-1.2.1-valgrind.patch
)

src_prepare() {
	default

	sed -i \
		-e 's:noinst_PROGRAMS:check_PROGRAMS:' \
		libspeex/Makefile.am || die

	eautoreconf
}

multilib_src_configure() {
	append-lfs-flags

	local myeconfargs=(
		$(multilib_native_use_enable valgrind)
		$(use_enable cpu_flags_x86_sse sse)
		$(use_enable vbr)
		$(multilib_native_use_with utils speexdsp)
		$(multilib_native_use_enable utils binaries)
	)

	local FIXED_ARG="--disable-fixed-point"
	local ARM4_ARG="--disable-arm4-asm"
	local ARM5_ARG="--disable-arm5e-asm"

	if use arm && ! use cpu_flags_arm_v6; then
		FIXED_ARG="--enable-fixed-point"

		if use cpu_flags_arm_v5; then
			ARM5_ARG="--enable-arm5e-asm"
		elif use cpu_flags_arm_v4; then
			ARM4_ARG="--enable-arm4-asm"
		fi
	fi

	myeconfargs+=( ${FIXED_ARG} ${ARM4_ARG} ${ARM5_ARG} )

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -type f -delete || die
}
