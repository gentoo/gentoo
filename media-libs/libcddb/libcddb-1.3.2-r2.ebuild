# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="A library for accessing a CDDB server"
HOMEPAGE="http://libcddb.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc static-libs"

RDEPEND=">=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-doc/doxygen )"

RESTRICT="test"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

MULTILIB_WRAPPED_HEADERS=( /usr/include/cddb/version.h )

multilib_src_configure() {
	local myconf=(
		--without-cdio
		$(use_enable static-libs static)
	)

	# bug 528012
	ECONF_SOURCE="${S}" CONFIG_SHELL="${BASH}" econf "${myconf[@]}"
}

src_compile() {
	multilib-minimal_src_compile

	if use doc; then
		cd "${S}"/doc || die
		doxygen doxygen.conf || die
	fi
}

src_install() {
	multilib-minimal_src_install

	use doc && dodoc -r "${S}"/doc/html

	find "${ED}" -type f \( -name '*.a' -o -name '*.la' \) -delete || die
}
