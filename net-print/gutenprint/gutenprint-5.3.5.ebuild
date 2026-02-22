# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools

DESCRIPTION="Ghostscript and cups printer drivers"
HOMEPAGE="https://gimp-print.sourceforge.io/"

MY_P="${P/_/-}"
SRC_URI="https://downloads.sourceforge.net/gimp-print/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

IUSE="cups nls readline ppds static-libs"
RESTRICT="test"

BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

RDEPEND="
	dev-lang/perl
	cups? ( >=net-print/cups-1.1.14 )
	readline? ( sys-libs/readline:0= )
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README doc/gutenprint-users-manual.{pdf,odt} )

src_prepare() {
	default

	# Needed for cflags patch
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-test
		--disable-translated-cups-ppds
		--disable-libgutenprintui2
		--without-gimp2
		--without-gimp2-as-gutenprint
		$(use_with cups)
		$(use_enable nls)
		$(use_with readline)
		$(use_enable static-libs static)
	)

	if use cups && use ppds; then
		myeconfargs+=(
			--enable-globalized-cups-ppds
			--enable-cups-1_2-enhancements
			--enable-cups-ppds
			--enable-cups-level3-ppds
		)
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

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	if [[ -x /usr/sbin/cups-genppdupdate ]]; then
		elog "Updating installed printer ppd files"
		elog $(/usr/sbin/cups-genppdupdate)
	else
		elog "You need to update installed ppds manually using cups-genppdupdate"
	fi
}
