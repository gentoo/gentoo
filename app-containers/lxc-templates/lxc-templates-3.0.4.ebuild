# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools verify-sig

DESCRIPTION="Old style template scripts for LXC"
HOMEPAGE="https://linuxcontainers.org/ https://github.com/lxc/lxc-templates"
SRC_URI="https://linuxcontainers.org/downloads/lxc/${P}.tar.gz
	verify-sig? ( https://linuxcontainers.org/downloads/lxc/${P}.tar.gz.asc )"

KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"

LICENSE="LGPL-3"
SLOT="0"

RDEPEND=">=app-containers/lxc-3.0"
DEPEND="${RDEPEND}"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-linuxcontainers )"

PATCHES=( "${FILESDIR}/${PN}-3.0.1-no-cache-dir.patch" )
DOCS=()

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/linuxcontainers.asc

src_prepare() {
	default
	eautoreconf
}
