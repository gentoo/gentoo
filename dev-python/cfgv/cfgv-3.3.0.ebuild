# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Validate configuration and produce human-readable error messages"
HOMEPAGE="https://github.com/asottile/cfgv"
SRC_URI="https://github.com/asottile/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~riscv"

distutils_enable_tests pytest
