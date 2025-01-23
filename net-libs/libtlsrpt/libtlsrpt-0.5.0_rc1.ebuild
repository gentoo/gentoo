# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	MY_P="libtlsrpt-${PV/_/}"
	EGIT_REPO_URI="https://github.com/sys4/tlsrpt.git"
	S="${WORKDIR}/${MY_P}/${PN}"
else
	MY_P="${PN}-${PV/_/}"
	SRC_URI="https://github.com/sys4/tlsrpt/releases/download/v${PV/_/}/${MY_P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="libraries and tools to implement TLSRPT"
HOMEPAGE="https://github.com/sys4/tlsrpt"

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
