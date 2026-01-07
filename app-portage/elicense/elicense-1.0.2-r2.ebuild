# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=(  python3_{12..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Tool to find installed packages in Gentoo with non-accepted license(s)"
HOMEPAGE="https://github.com/Whissi/elicense"
SRC_URI="https://github.com/Whissi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND=">=sys-apps/portage-2.3.62[${PYTHON_USEDEP}]"

src_prepare() {
	default

	sed -i -e "s/^MY_PV =.*$/MY_PV = \"${PV}\"/" elicense || die
}
