# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Unicode string library"
HOMEPAGE="https://libs.suckless.org/libgrapheme/"
SRC_URI="https://dl.suckless.org/libgrapheme/${P}.tar.gz"

LICENSE="ISC Unicode-DFS-2016"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 x86"
# upstream suggests keeping the static option, others have requested it too
IUSE="static-libs"

src_prepare() {
	default

	append-cflags ${CPPFLAGS}
	tc-export CC AR RANLIB
	tc-export_build_env BUILD_CC
	sed -Ei '/^(BUILD_|)(CC|AR|RANLIB|CFLAGS|LDFLAGS|LDCONFIG).*=/d' config.mk || die

	# does use libc and dropping this avoids QA noise with clang (bug #895068)
	sed -i 's/-nostdlib //' config.mk || die
}

src_configure() { :; }

src_install() {
	local emakeargs=(
		DESTDIR="${D}"
		PREFIX="${EPREFIX}"/usr
		LIBPREFIX="${EPREFIX}"/usr/$(get_libdir)
	)

	emake "${emakeargs[@]}" install
	einstalldocs

	use static-libs || rm "${ED}"/usr/$(get_libdir)/${PN}.a || die
}
