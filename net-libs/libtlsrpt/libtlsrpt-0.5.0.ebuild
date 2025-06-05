# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	MY_P="${PN}${PV/_/-}"
	EGIT_REPO_URI="https://github.com/sys4/${PN}.git"
else
	MY_P="${PN}-${PV/_/-}"
	SRC_URI="https://github.com/sys4/${PN}/releases/download/v${PV/_/-}/${MY_P}.tar.gz"
	KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~sparc x86"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="library to implement TLSRPT"
HOMEPAGE="https://github.com/sys4/libtlsrpt"

LICENSE="LGPL-3+"
SLOT="0"

RDEPEND="${DEPEND}"

src_prepare() {
	if [[ ${PV} == 9999 ]]; then
		eautoreconf
	fi
	default
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
