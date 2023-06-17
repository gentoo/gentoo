# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Manages Zig versions"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	app-admin/eselect
	!dev-lang/zig:0
	!dev-lang/zig-bin:0
"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/eselect/modules/
	newins "${FILESDIR}"/zig.eselect-${PVR} zig.eselect
}
