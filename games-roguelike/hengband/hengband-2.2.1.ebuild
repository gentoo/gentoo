# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="An Angband variant, with a Japanese/fantasy theme"
HOMEPAGE="https://hengband.github.io/"
SRC_URI="https://github.com/hengband/hengband/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Moria"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X l10n_ja"

RDEPEND="
	>=sys-libs/ncurses-5:0=
	X? ( x11-libs/libX11 )
"
DEPEND="
	${RDEPEND}
	X? ( x11-libs/libXt )
"
BDEPEND="
	virtual/pkgconfig
	l10n_ja? ( app-i18n/nkf )
"

PATCHES=(
	"${FILESDIR}/${PN}-2.1.2-autoconf-ncurses.patch"
)

src_prepare() {
	# Fix syntax for chown.
	sed -i '/chown/s/\./:/' lib/*/Makefile.am || die
	# Don't use the games sub-dir since we're not using games.eclass any more.
	sed -i 's:/games/:/:g' configure.ac || die

	default
	eautoreconf
}

src_configure() {
	local myconf=(
		--bindir="${EPREFIX}"/usr/bin
		--with-setgid="nobody"
		$(use_with X x)
	)
	use l10n_ja || myconf+=( --disable-japanese )

	econf "${myconf[@]}"
}

src_install() {
	default
	dodoc lib/help/faq.txt

	if use l10n_ja ; then
		dodoc readme.txt autopick.txt readme_eng.txt autopick_eng.txt
	else
		newdoc readme_eng.txt readme.txt
		newdoc autopick_eng.txt autopick.txt
	fi
}
