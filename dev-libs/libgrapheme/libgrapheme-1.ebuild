# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Unicode string library"
HOMEPAGE="https://libs.suckless.org/libgrapheme/"
SRC_URI="https://dl.suckless.org/libgrapheme/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-make.patch
)

src_configure() {
	tc-export CC AR RANLIB
	tc-export_build_env BUILD_CC # see make.patch

	append-ldflags -Wl,--soname=${PN}.so
}

src_install() {
	local emakeargs=(
		DESTDIR="${D}"
		PREFIX="${EPREFIX}"/usr
		LIBPREFIX="${EPREFIX}"/usr/$(get_libdir)
	)
	emake "${emakeargs[@]}" install
	einstalldocs

	rm "${ED}"/usr/$(get_libdir)/${PN}.a || die
}
