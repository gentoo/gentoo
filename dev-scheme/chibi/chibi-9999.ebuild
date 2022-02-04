# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Minimal Scheme implementation for use as an extension language"
HOMEPAGE="http://synthcode.com/scheme/chibi/"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ashinn/${PN}-scheme.git"
else
	SRC_URI="https://github.com/ashinn/${PN}-scheme/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-scheme-${PV}"
fi

LICENSE="BSD"
SLOT="0"

src_configure() {
	tc-export CC

	export PREFIX="${EPREFIX}/usr"
	export LIBDIR="${EPREFIX}/usr/$(get_libdir)"
	export SOLIBDIR="${EPREFIX}/usr/$(get_libdir)"

	# if ldconfig (stored in LDCONFIG variable) exists it is ran
	export LDCONFIG="0"
}

src_install() {
	default

	dosym chibi-scheme /usr/bin/chibi
}
