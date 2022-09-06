# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="Set of utility libraries (mostly used by sssd)"
HOMEPAGE="https://github.com/SSSD/ding-libs"
SRC_URI="https://github.com/SSSD/ding-libs/releases/download/${PV}/${P}.tar.gz"

LICENSE="LGPL-3 GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-libs/check )"
BDEPEND="virtual/pkgconfig"

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf
}

multilib_src_install_all() {
	einstalldocs

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
