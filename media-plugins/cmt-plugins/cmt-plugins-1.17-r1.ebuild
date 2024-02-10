# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib toolchain-funcs multilib-minimal

MY_P="cmt_${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="CMT (computer music toolkit) LADSPA library plugins"
HOMEPAGE="https://www.ladspa.org/"
SRC_URI="https://www.ladspa.org/download/${MY_P}.tgz"

KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~loong ppc ppc64 ~riscv sparc x86"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND=">=media-libs/ladspa-sdk-1.13-r2[${MULTILIB_USEDEP}]"
RDEPEND=""

PATCHES=(
	"${FILESDIR}/${P}-makefile.patch"
	"${FILESDIR}/${P}-clang.patch"
)

DOCS="../README"
HTML_DOCS="../doc/*"

src_prepare() {
	default

	use elibc_Darwin && eapply "${FILESDIR}/${P}-darwin.patch"

	multilib_copy_sources
}

multilib_src_compile() {
	cd src
	tc-export CXX
	emake PLUGIN_LIB="cmt.so"
}

multilib_src_install() {
	cd src
	insopts -m755
	insinto /usr/$(get_libdir)/ladspa
	doins *.so
}

multilib_src_install_all() {
	cd src
	insinto /usr/share/ladspa/rdf/
	doins "${FILESDIR}/cmt.rdf"

	einstalldocs
}
