# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop xdg

DESCRIPTION="French conjugation system"
HOMEPAGE="http://sarrazip.com/dev/verbiste.html"
SRC_URI="http://sarrazip.com/dev/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ~riscv x86"
IUSE="gui test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/libxml2-2.4.0:2=
	virtual/libiconv
	virtual/libintl
	gui? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf:2
		>=x11-libs/gtk+-2.6:2
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/perl
	dev-perl/XML-Parser
	virtual/pkgconfig
	test? ( dev-libs/libxml2 )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.1.49-posix_shell.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# use libc.so provided by musl for gettext' symbols
	use elibc_musl && export gt_cv_func_gnugettext1_libc=yes

	local myeconfargs=(
		--with-console-app
		--without-gnome-app
		--without-gnome-applet
		$(use_with gui gtk-app)
	)
	econf "${myeconfargs[@]}"
}

src_test() {
	emake VERBOSE=1 check
}

src_install() {
	default

	dodoc HACKING LISEZMOI

	# file is only installed with USE=gnome
	if use gui; then
		sed -e 's/Exec=.*/Exec=verbiste-gtk/' \
			-i src/gnome/verbiste.desktop || die
		domenu src/gnome/verbiste.desktop
	fi

	rm "${ED}/usr/share/doc/${PF}/COPYING" || die
	find "${ED}" -name '*.la' -delete || die
}
