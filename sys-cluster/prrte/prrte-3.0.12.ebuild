# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic libtool

DESCRIPTION="PMIx Reference RunTime Environment"
HOMEPAGE="https://openpmix.github.io/"
SRC_URI="https://github.com/openpmix/prrte/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64 ~ppc64"

DEPEND="
	dev-libs/libevent:=
	sys-apps/hwloc:=
	>=sys-cluster/pmix-4.2.4
"
RDEPEND="${DEPEND}"

# Tests are only in the repo, not in release tarballs
# They also seem to be just examples
RESTRICT="test"

src_prepare() {
	default
	elibtoolize
}

src_configure() {
	# -Werror=lto-type-mismatch
	#
	# Same issue as its companion project sys-cluster/pmix, and logically
	# solvable in tandem (or never).
	# https://github.com/openpmix/openpmix/issues/3350
	filter-lto

	econf
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
