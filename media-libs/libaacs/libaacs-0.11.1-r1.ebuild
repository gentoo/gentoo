# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="Open implementation of the Advanced Access Content System (AACS) specification"
HOMEPAGE="https://www.videolan.org/developers/libaacs.html"
SRC_URI="https://downloads.videolan.org/pub/videolan/libaacs/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 ~riscv ~sparc x86"

RDEPEND=">=dev-libs/libgcrypt-1.5.3:0=[${MULTILIB_USEDEP}]
	>=dev-libs/libgpg-error-1.12[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/flex
	virtual/yacc"

DOCS=( ChangeLog KEYDB.cfg README.md )

multilib_src_configure() {
	local myeconfargs=(
		--disable-optimizations
		--enable-shared
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"

	# Workaround automake bug: https://debbugs.gnu.org/cgi/bugreport.cgi?bug=54390
	mkdir -p "${BUILD_DIR}"/src/file || die
}

multilib_src_install_all() {
	einstalldocs

	find "${ED}" -type f -name "*.la" -delete || die
}
