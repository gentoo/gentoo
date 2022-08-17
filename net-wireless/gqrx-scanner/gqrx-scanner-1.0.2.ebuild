# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="frequency scanner for Gqrx Software Defined Radio receiver"
HOMEPAGE="https://github.com/neural75/gqrx-scanner"
SRC_URI="https://github.com/neural75/gqrx-scanner/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
PDEPEND="net-wireless/gqrx"
