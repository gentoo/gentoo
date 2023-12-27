# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )

inherit toolchain-funcs python-any-r1

MY_KVER="6.4.7"

DESCRIPTION="Linux kernel shared object for libkrun"
HOMEPAGE="https://github.com/containers/libkrunfw"
SRC_URI="
	https://github.com/containers/libkrunfw/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${MY_KVER}.tar.xz
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~arm64"
IUSE="asahi"

DEPEND="
	${PYTHON_DEPS}
"
BDEPEND="
	dev-python/pyelftools
"

# Upstream tries to download the kernel sources at build time. We grab them and
# unpack them in src_unpack(), so patch this out and mark the target as phony.
# Also pass through KARCH so that the vendored kernel builds correctly.
PATCHES=(
	"${FILESDIR}/patch-makefile.patch"
)

python_check_deps() {
	python_has_version "dev-python/pyelftools[${PYTHON_USEDEP}]"
}

src_unpack() {
	default
	mv "${WORKDIR}/linux-${MY_KVER}" "${S}/." || die "Could not move kernel sources into build tree"
}

src_prepare() {
	default
	use asahi && eapply "${FILESDIR}/asahi-config.patch"
}

src_compile() {
	# WAR: Makefile finds aarch64, kernel expects arm64
	emake KARCH=$(tc-arch-kernel) all
}

src_install() {
	emake PREFIX="${D}/usr/" install
}
