# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Library for parsing Embedded OpenType files (Microsoft embedded font 'standard')"
HOMEPAGE="https://github.com/umanwizard/libeot"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/umanwizard/libeot.git"
else
	SRC_URI="https://github.com/umanwizard/libeot/archive/v${PV}.tar.gz -> ${P}.tgz"
	KEYWORDS="~amd64 ~riscv x86"
fi

LICENSE="MPL-2.0"
SLOT="0"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
