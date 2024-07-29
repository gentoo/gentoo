# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

REAL_PN="${PN}-scheme"
REAL_PV="$(ver_cut 1-2)"
REAL_P="${REAL_PN}-${REAL_PV}"

inherit toolchain-funcs

DESCRIPTION="Minimal Scheme implementation for use as an extension language"
HOMEPAGE="http://synthcode.com/scheme/chibi/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/ashinn/${REAL_PN}.git"
else
	SRC_URI="https://github.com/ashinn/${REAL_PN}/archive/${REAL_PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${REAL_P}"

	KEYWORDS="~amd64 ~riscv ~x86"
fi

LICENSE="BSD"
SLOT="0"

src_configure() {
	tc-export CC

	export PREFIX="${EPREFIX}/usr"
	export LIBDIR="${EPREFIX}/usr/$(get_libdir)"
	export SOLIBDIR="${EPREFIX}/usr/$(get_libdir)"

	# If "ldconfig" exists it is ran, overwrite it with "LDCONFIG" variable.
	export LDCONFIG="0"
}

src_install() {
	default

	dosym "${REAL_PN}" "/usr/bin/${PN}"
}
