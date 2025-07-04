# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )

inherit python-single-r1 toolchain-funcs flag-o-matic

DESCRIPTION="A collection of latency testing tools for the linux(-rt) kernel"
HOMEPAGE="https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git/"
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

PATCHES=(
	"${FILESDIR}/${P}-glibc.patch"
)

src_prepare() {
	default
	use elibc_musl && eapply "${FILESDIR}/${P}-musl.patch"
}

src_compile() {
	append-lfs-flags
	emake CC="$(tc-getCC)" AR="$(tc-getAR)"
}

src_install() {
	emake CC="$(tc-getCC)" prefix=/usr DESTDIR="${ED}" install
	python_fix_shebang "${ED}"
	python_optimize
}
