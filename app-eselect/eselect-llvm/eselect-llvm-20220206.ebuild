# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Eselect module for management of multiple llvm versions"
HOMEPAGE="https://github.com/Infrasonics/eselect-llvm"
SRC_URI="https://github.com/Infrasonics/eselect-llvm/releases/download/${PV}/llvm.eselect-${PV}.xz"

S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=app-admin/eselect-1.4.15"

src_install() {
	insinto /usr/share/eselect/modules
	newins llvm.eselect-${PV} llvm.eselect
}
