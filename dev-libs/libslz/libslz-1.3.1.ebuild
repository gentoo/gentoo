# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Stateless, zlib-compatible, and very fast compression library"
HOMEPAGE="http://www.libslz.org/"
SRC_URI="https://github.com/wtarreau/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/1"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="tools"

src_compile() {
	local opts=(
		CC="$(tc-getCC)"
		OPT_CFLAGS="${CFLAGS}"
		USR_LFLAGS="${LDFLAGS}"
		shared
		$(usev tools)
	)

	emake "${opts[@]}"
}

src_install() {
	local opts=(
		STRIP=":"
		DESTDIR="${D}"
		PREFIX="${EPREFIX}/usr"
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		install-headers
		install-shared
		$(usev tools install-tools)
	)

	einstalldocs

	emake "${opts[@]}"
}
