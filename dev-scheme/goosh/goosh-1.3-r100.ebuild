# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
inherit guile

DESCRIPTION="Small process-control library for Guile"
HOMEPAGE="http://arglist.com/guile/"
SRC_URI="http://arglist.com/guile/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"

REQUIRED_USE="${GUILE_REQUIRED_USE}"

RDEPEND="${GUILE_DEPS}"
BDEPEND="${RDEPEND}"
