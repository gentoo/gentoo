# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Manages Zig versions"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~x86"

RDEPEND="app-admin/eselect"

src_install() {
	insinto /usr/share/eselect/modules/
	newins "${FILESDIR}"/zig.eselect-${PVR} zig.eselect
}
