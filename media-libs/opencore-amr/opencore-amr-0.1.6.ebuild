# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="Implementation of Adaptive Multi Rate Narrowband and Wideband speech codec"
HOMEPAGE="https://sourceforge.net/projects/opencore-amr/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~x64-macos"

multilib_src_configure() {
	ECONF_SOURCE=${S} econf --disable-static
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name "*.la" -delete || die
}
