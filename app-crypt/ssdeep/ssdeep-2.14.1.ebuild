# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="Computes context triggered piecewise hashes (fuzzy hashes)"
HOMEPAGE="https://ssdeep-project.github.io/ssdeep/"
SRC_URI="https://github.com/${PN}-project/${PN}/releases/download/release-${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~riscv x86"
IUSE="static-libs"

DOCS=(
	AUTHORS
	ChangeLog
	FILEFORMAT
	NEWS
	README
	TODO
)

PATCHES=(
	"${FILESDIR}/${PN}-2.10-shared.patch"
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
		econf \
			$(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
