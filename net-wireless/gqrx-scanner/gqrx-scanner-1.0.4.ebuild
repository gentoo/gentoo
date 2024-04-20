# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="frequency scanner for Gqrx Software Defined Radio receiver"
HOMEPAGE="https://github.com/neural75/gqrx-scanner"
SRC_URI="https://github.com/neural75/gqrx-scanner/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE=""

RDEPEND="net-wireless/gqrx"
