# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/glpk/glpk-4.55.ebuild,v 1.1 2015/02/27 14:14:35 jlec Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit eutils flag-o-matic toolchain-funcs autotools-utils

DESCRIPTION="GNU Linear Programming Kit"
LICENSE="GPL-3"
HOMEPAGE="http://www.gnu.org/software/glpk/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

SLOT="0/36"
IUSE="doc examples gmp odbc mysql static-libs"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"

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
	"${FILESDIR}"/${PN}-4.54-debundle-system-libs.patch
)

src_configure() {
	local myeconfargs=(
		$(use_enable mysql)
		$(use_enable odbc)
		$(use_with gmp)
	)
	if use mysql || use odbc; then
		myeconfargs+=( --enable-dl )
	else
		myeconfargs+=( --disable-dl )
	fi
	[[ -z $(type -P odbc-config) ]] && \
		append-cppflags $($(tc-getPKG_CONFIG) --cflags libiodbc)

	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	use doc && dodoc doc/*.pdf doc/notes/*.pdf doc/*.txt
}
