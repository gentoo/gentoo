# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Ghostscript and cups printer drivers"
HOMEPAGE="http://gutenprint.sourceforge.net"

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"
SRC_URI="mirror://sourceforge/gimp-print/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="cups gimp gtk nls readline ppds static-libs"
REQUIRED_USE="gimp? ( gtk )"

BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
CDEPEND="
	dev-lang/perl
	readline? ( sys-libs/readline:0= )
	cups? ( >=net-print/cups-1.1.14 )
	gimp? ( >=media-gfx/gimp-2.2 x11-libs/gtk+:2 )
	gtk? ( x11-libs/gtk+:2 )
	nls? ( virtual/libintl )
"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}"

RESTRICT="test"

DOCS=( AUTHORS ChangeLog NEWS README doc/gutenprint-users-manual.{pdf,odt} )

PATCHES=(
	"${FILESDIR}"/${PN}-5.3.1-cflags.patch
)

src_configure() {
	local myeconfargs=(
		--enable-test
		--disable-translated-cups-ppds
		$(use_enable gtk libgutenprintui2)
		$(use_with gimp gimp2)
		$(use_with gimp gimp2-as-gutenprint)
		$(use_with cups)
		$(use_enable nls)
		$(use_with readline)
		$(use_enable static-libs static)
	)

	if use cups && use ppds; then
		myeconfargs+=( --enable-cups-ppds --enable-cups-level3-ppds )
	else
		myeconfargs+=( --disable-cups-ppds )
	fi

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	dodoc doc/FAQ.html
	dodoc -r doc/gutenprintui2/html
	rm -r "${ED}"/usr/share/gutenprint/doc || die

	find "${ED}" -name '*.la' -exec rm -f '{}' + || die
}

pkg_postinst() {
	if [[ ${ROOT} == / ]] && [[ -x /usr/sbin/cups-genppdupdate ]]; then
		elog "Updating installed printer ppd files"
		elog $(/usr/sbin/cups-genppdupdate)
	else
		elog "You need to update installed ppds manually using cups-genppdupdate"
	fi
}
