# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Move/copy/append/link multiple files according to a set of wildcard patterns"
HOMEPAGE="https://github.com/rrthomas/mmv"
SRC_URI="https://github.com/rrthomas/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ppc ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

QA_CONFIG_IMPL_DECL_SKIP=( MIN )
