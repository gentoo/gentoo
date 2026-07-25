# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library to parse and emit YAML, and do it fast"
HOMEPAGE="https://github.com/biojppm/rapidyaml/"
SRC_URI="
	https://github.com/biojppm/rapidyaml/releases/download/v${PV}/${P}-src.tgz
"
S=${WORKDIR}/${P}-src

LICENSE="MIT Boost-1.0 BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

# in general would rather keep this package low maintenance due to
# its build system, and tests + python bindings give headaches
RESTRICT="test"

DOCS=( README.md ROADMAP.md changelog )
