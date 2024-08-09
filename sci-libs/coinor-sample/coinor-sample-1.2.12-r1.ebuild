# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=Data-Sample

DESCRIPTION="COIN-OR Sample models"
HOMEPAGE="https://github.com/coin-or-tools/Data-Sample/"
SRC_URI="https://github.com/coin-or-tools/${MY_PN}/archive/releases/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-releases-${PV}"

LICENSE="EPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~loong ~riscv ~x86 ~amd64-linux ~x86-linux"
