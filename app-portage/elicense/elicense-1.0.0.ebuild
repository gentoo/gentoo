# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} )
inherit distutils-r1

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/Whissi/elicense.git"
	inherit git-r3
else
	SRC_URI="https://github.com/Whissi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-fbsd"
fi

DESCRIPTION="Tool to find installed packages in Gentoo with non-accepted license(s)"
HOMEPAGE="https://github.com/Whissi/elicense"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND=">=sys-apps/portage-2.3.62[${PYTHON_USEDEP}]"
