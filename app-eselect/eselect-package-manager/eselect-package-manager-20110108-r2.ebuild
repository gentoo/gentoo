# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Manages PACKAGE_MANAGER environment variable"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Eselect"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND=">=app-admin/eselect-1.1.1"

src_install() {
	insinto /usr/share/eselect/modules
	doins package-manager.eselect
	doman package-manager.eselect.5
}
