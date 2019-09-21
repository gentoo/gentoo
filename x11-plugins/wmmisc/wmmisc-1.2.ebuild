# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="a monitoring dockapp for system load, user amount, fork amount and processes"
HOMEPAGE="https://www.dockapps.net/wmmisc"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

RDEPEND=">=x11-libs/libdockapp-0.7:="
DEPEND="${RDEPEND}"
