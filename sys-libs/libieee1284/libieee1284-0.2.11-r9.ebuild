# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

DESCRIPTION="Library to query devices using IEEE1284"
HOMEPAGE="http://cyberelk.net/tim/software/libieee1284/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc x86"
IUSE="doc static-libs"

BDEPEND="doc? (
		app-text/docbook-sgml-utils
		>=app-text/docbook-sgml-dtd-4.1
		app-text/docbook-dsssl-stylesheets
		dev-perl/XML-RegExp
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.11-don-t-blindly-assume-outb_p-to-be-available.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die

	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--enable-shared
		--without-python
		$(use_enable static-libs static)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	dodoc doc/interface*

	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi
}
