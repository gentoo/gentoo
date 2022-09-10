# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
fi

DESCRIPTION="A set of backgrounds packaged with the MATE desktop"
LICENSE="CC-BY-SA-4.0 GPL-2+"
SLOT="0"

DEPEND="
	>=sys-devel/gettext-0.19.8:*
"
