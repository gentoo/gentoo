# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_{6,7,8})

inherit python-single-r1

DESCRIPTION="A collection of latency testing tools for the linux(-rt) kernel"
HOMEPAGE="https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git/about/"
SRC_URI="
	https://kernel.org/pub/linux/utils/rt-tests/${P}.tar.xz
	https://kernel.org/pub/linux/utils/rt-tests/older/${P}.tar.xz"

LICENSE="GPL-2 GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="numa"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	numa? ( sys-process/numactl )"
RDEPEND="${DEPEND}"

src_compile() {
	emake $(usex numa 'NUMA=1' 'NUMA=0') all
}

src_install() {
	emake prefix=/usr DESTDIR="${D}" MAN_COMPRESSION=none install
	python_fix_shebang "${ED}"
	python_optimize
}
