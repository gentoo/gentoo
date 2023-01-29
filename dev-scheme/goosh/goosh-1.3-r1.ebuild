# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Small process-control library for Guile"
HOMEPAGE="http://arglist.com/guile/"
SRC_URI="http://arglist.com/guile/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~riscv x86"
IUSE=""

RDEPEND=">=dev-scheme/guile-1.6"
DEPEND="${RDEPEND}"
