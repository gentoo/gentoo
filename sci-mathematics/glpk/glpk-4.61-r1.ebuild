# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="GNU Linear Programming Kit"
LICENSE="GPL-3"
HOMEPAGE="https://www.gnu.org/software/glpk/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

SLOT="0/40"
IUSE="doc examples gmp odbc mysql static-libs"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"

RDEPEND="
	sci-libs/amd:0=
	sci-libs/colamd:=
	sys-libs/zlib:0=
	gmp? ( dev-libs/gmp:0= )
	mysql? ( virtual/mysql )
	odbc? ( || ( dev-db/libiodbc:0 dev-db/unixODBC:0 ) )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-4.60-debundle-system-libs.patch
)

src_prepare() {
	use odbc && [[ -z $(type -P odbc_config) ]] && \
		append-cppflags $($(tc-getPKG_CONFIG) --cflags libiodbc)

	default
	eautoreconf
}

src_configure() {
	local myconf
	if use mysql || use odbc; then
		myconf="--enable-dl"
	else
		myconf="--disable-dl"
	fi

	econf ${myconf} \
		$(use_enable mysql) \
		$(use_enable odbc) \
		$(use_enable static-libs static) \
		$(use_with gmp)
}

src_install() {
	default
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	use doc && dodoc doc/*.pdf doc/notes/*.pdf doc/*.txt
}
