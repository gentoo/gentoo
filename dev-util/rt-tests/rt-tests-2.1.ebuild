# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit python-single-r1 toolchain-funcs

DESCRIPTION="A collection of latency testing tools for the linux(-rt) kernel"
HOMEPAGE="https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git/about/"
SRC_URI="
	https://kernel.org/pub/linux/utils/rt-tests/${P}.tar.xz
	https://kernel.org/pub/linux/utils/rt-tests/older/${P}.tar.xz"

LICENSE="GPL-2 GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	sys-process/numactl"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	use elibc_musl && eapply "${FILESDIR}/${P}-musl.patch"
}

src_compile() {
	emake CC="$(tc-getCC)" AR="$(tc-getAR)"
}

src_install() {
	emake prefix=/usr DESTDIR="${ED}" install
	python_fix_shebang "${ED}"
	python_optimize
}
