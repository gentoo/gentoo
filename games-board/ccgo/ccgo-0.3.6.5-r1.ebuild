# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils toolchain-funcs flag-o-matic

DESCRIPTION="An IGS client written in C++"
HOMEPAGE="https://ccdw.org/~cjj/prog/ccgo/"
SRC_URI="https://ccdw.org/~cjj/prog/ccgo/src/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	>=dev-cpp/gconfmm-2.6
	>=dev-cpp/gtkmm-2.4:2.4
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${P}-gcc4.patch
	"${FILESDIR}"/${P}-tinfo.patch
)

src_prepare() {
	default

	sed -i \
		-e '/^Encoding/d' \
		-e '/^Categories/ { s/Application;//; s/$/GTK;/ }' \
		ccgo.desktop.in || die

	sed -i \
		-e '/^localedir/s/=.*/=@localedir@/' \
		-e '/^appicondir/s:=.*:=/usr/share/pixmaps:' \
		-e '/^desktopdir/s:=.*:=/usr/share/applications:' \
		Makefile.am || die

	# cargo cult from bug #569528
	append-cxxflags -std=c++11 -fpermissive

	find . -name '*.hh' -exec sed -i -e '/sigc++\/object.h/d' {} + || die
	find . -name '*.cc' -exec sed -i -e 's/(bind(/(sigc::bind(/' {} + || die

	eautoreconf
}

src_configure() {
	econf \
		--localedir=/usr/share/locale \
		$(use_enable nls)
}

src_compile() {
	emake AR="$(tc-getAR)"
}
