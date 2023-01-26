# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Library for parsing Embedded OpenType files (Microsoft embedded font 'standard')"
HOMEPAGE="https://github.com/umanwizard/libeot"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/umanwizard/libeot.git"
	inherit git-r3
else
	SRC_URI="https://github.com/umanwizard/libeot/archive/v${PV}.tar.gz -> ${P}.tgz"
	KEYWORDS="~amd64 ~x86"
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
