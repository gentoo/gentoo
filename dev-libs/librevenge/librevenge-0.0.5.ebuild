# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://git.code.sf.net/p/libwpd/librevenge"
	inherit git-r3 autotools
else
	SRC_URI="https://sf.net/projects/libwpd/files/${PN}/${P}/${P}.tar.xz"
	KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
fi

DESCRIPTION="Helper library for REVerse ENGineered formats filters"
HOMEPAGE="https://sourceforge.net/p/libwpd/librevenge/ci/master/tree/"

LICENSE="|| ( MPL-2.0 LGPL-2.1 )"
SLOT="0"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="sys-libs/zlib[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	dev-libs/boost
	test? ( dev-util/cppunit[${MULTILIB_USEDEP}] )"
BDEPEND="doc? ( app-text/doxygen[dot] )"

src_prepare() {
	default
	[[ ${PV} == *9999 ]] && eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		$(multilib_native_use_with doc docs)
		$(use_enable test tests)
	)
	ECONF_SOURCE=${S} econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -type f -delete || die
}
