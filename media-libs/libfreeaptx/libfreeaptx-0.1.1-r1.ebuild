# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic multilib-minimal toolchain-funcs

DESCRIPTION="Reverse-engineered aptX and aptX HD library (fork of libopenaptx)"
HOMEPAGE="https://github.com/iamthehorker/libfreeaptx"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/iamthehorker/${PN}"
else
	SRC_URI="https://github.com/iamthehorker/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="cpu_flags_x86_avx2"

PATCHES=(
	"${FILESDIR}"/${P}-fix-version.patch
)

src_prepare() {
	default

	# custom Makefiles
	multilib_copy_sources
}

multilib_src_compile() {
	tc-export CC AR

	use cpu_flags_x86_avx2 && append-cflags "-mavx2"

	emake \
		PREFIX="${EPREFIX}"/usr \
		LIBDIR=$(get_libdir) \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		ARFLAGS="${ARFLAGS} -rcs" \
		all
}

multilib_src_install() {
	emake \
		PREFIX="${EPREFIX}"/usr \
		DESTDIR="${D}" \
		LIBDIR="$(get_libdir)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		ARFLAGS="${ARFLAGS} -rcs" \
		install
}
