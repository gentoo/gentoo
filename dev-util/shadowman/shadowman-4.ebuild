# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Unified compiler shadow link directory updater"
HOMEPAGE="https://github.com/projg2/shadowman"
SRC_URI="https://github.com/projg2/shadowman/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="app-admin/eselect"
DEPEND="${RDEPEND}"

src_install() {
	# tool modules are split into their respective packages
	emake DESTDIR="${D}" prefix="${EPREFIX}"/usr install \
		INSTALL_MODULES_TOOL=""
	keepdir /usr/share/shadowman/tools
}
