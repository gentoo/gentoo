# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="Library for accessing Microsoft Media Server (MMS) media streaming protocol"
HOMEPAGE="https://sourceforge.net/projects/libmms/ https://launchpad.net/libmms/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"

BDEPEND="virtual/pkgconfig"

multilib_src_configure() {
	ECONF_SOURCE=${S} econf --disable-static
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name "*.la" -delete || die
}
