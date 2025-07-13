# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="C++ library for real-time resampling of audio signals"
HOMEPAGE="https://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0/1"
KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
IUSE="cpu_flags_arm_neon cpu_flags_x86_sse2 tools"

RDEPEND="tools? ( media-libs/libsndfile )"
DEPEND="${RDEPEND}"

HTML_DOCS="docs/."

PATCHES=( "${FILESDIR}"/${PN}-1.11.2-makefile.patch )

src_compile() {
	tc-export CXX
	# Code paths that uses intrinsics are not properly guarded by symbol checks
	if use cpu_flags_x86_sse2 ; then
		if tc-cpp-is-true "defined(__SSE2__)" ${CFLAGS} ${CXXFLAGS} ; then
			append-cppflags "-DENABLE_SSE2"
		else
			ewarn "SSE2 support has been disabled automatically because the"
			ewarn "compiler does not support corresponding intrinsics"
		fi
	elif use cpu_flags_arm_neon ; then
		if tc-cpp-is-true "defined(__ARM_NEON__)" ${CFLAGS} ${CXXFLAGS} ; then
			append-cppflags "-DENABLE_NEON"
		else
			ewarn "NEON support has been disabled automatically because the"
			ewarn "compiler does not support corresponding intrinsics"
		fi
	fi

	emake -C source
	if use tools; then
		emake -C apps
	fi
}

src_install() {
	local myemakeargs=(
		DESTDIR="${D}"
		PREFIX="${EPREFIX}/usr"
		LIBDIR="${EPREFIX}"/usr/$(get_libdir)
	)
	emake -C source "${myemakeargs[@]}" install
	if use tools; then
		emake -C apps "${myemakeargs[@]}" install
	fi

	einstalldocs
}
