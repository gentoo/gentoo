# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Userspace tools for MMC/SD devices"
HOMEPAGE="https://git.kernel.org/pub/scm/utils/mmc/mmc-utils.git/"

SRC_URI="https://git.kernel.org/pub/scm/utils/mmc/mmc-utils.git/snapshot/mmc-utils-${PV}.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"

KEYWORDS="~amd64 ~arm64"

IUSE="doc"

RDEPEND="!dev-lang/mercury"
BDEPEND="doc? ( dev-python/sphinx )"

src_prepare() {
	default
	sed -i \
		-e '/^GIT_VERSION /d' \
		-e 's/-Werror //' \
		-e 's/-D_FORTIFY_SOURCE=2 //' \
		-e "s/-DVERSION=.*/-DVERSION=\\\\\"gentoo-${PVR}\\\\\"/" \
		Makefile || die
}

src_configure() {
	tc-export CC
}

src_compile() {
	emake C=0
	use doc && emake -C docs html
}

src_install() {
	dosbin mmc
	dodoc README
	doman man/mmc.1
	if use doc; then
		docinto html
		dodoc -r docs/_build/html/.
	fi
}
