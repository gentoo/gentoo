# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic multilib-minimal

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="git://git.code.sf.net/p/libwpd/librevenge"
	inherit git-r3 autotools
else
	SRC_URI="https://sf.net/projects/libwpd/files/${PN}/${P}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
fi
DESCRIPTION="Helper library for REVerse ENGineered formats filters"
HOMEPAGE="https://sf.net/p/libwpd/librevenge"

LICENSE="|| ( MPL-2.0 LGPL-2.1 )"
SLOT="0"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	doc? ( app-doc/doxygen )
"
RDEPEND="
	sys-libs/zlib[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-libs/boost
	test? ( dev-util/cppunit[${MULTILIB_USEDEP}] )
"

src_prepare() {
	default
	[[ ${PV} = *9999 ]] && eautoreconf

	# bug 651264
	append-cxxflags -std=c++11
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-static
		--disable-werror
		$(use_with doc docs)
		$(use_enable test tests)
	)
	ECONF_SOURCE=${S} econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -type f -delete || die
}
