# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/umanwizard/libeot.git"
inherit autotools
[[ ${PV} == 9999 ]] && inherit git-r3

DESCRIPTION="Library for parsing Embedded OpenType files (Microsoft embedded font 'standard')"
HOMEPAGE="https://github.com/umanwizard/libeot"
[[ ${PV} == 9999 ]] || SRC_URI="https://github.com/umanwizard/libeot/archive/v${PV}.tar.gz -> ${P}.tgz"

LICENSE="MPL-2.0"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="amd64 ~riscv x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
