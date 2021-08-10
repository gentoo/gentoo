# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic multilib toolchain-funcs

MY_P="wmii+ixp-${PV}"

DESCRIPTION="A dynamic window manager for X11"
HOMEPAGE="https://github.com/0intro/wmii"
SRC_URI="http://dl.suckless.org/wmii/${MY_P}.tbz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"

DEPEND="
	media-libs/freetype
	>=sys-libs/libixp-0.5_p20110208-r3
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libX11"
RDEPEND="${DEPEND}
	media-fonts/font-misc-misc
	x11-apps/xmessage
	x11-apps/xsetroot"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

DOCS=( NEWS NOTES README TODO )

# Force dynamic linking, bug #273332
MAKEOPTS="${MAKEOPTS} STATIC= -j1"

src_prepare() {
	default
	mywmiiconf=(
		PREFIX=/usr
		DOC=/usr/share/doc/${PF}
		ETC=/etc
		LIBDIR=/usr/$(get_libdir)
		CC="$(tc-getCC) -c"
		LD="$(tc-getCC)"
		AR="$(tc-getAR) crs"
		DESTDIR="${D}"
		LIBIXP=/usr/$(get_libdir)/libixp.so
	)

	# punt internal copy of sys-libs/libixp #323037
	rm include/ixp{,_srvutil}.h || die
	sed -i -e '/libixp/d' Makefile || die

	sed -i -e "/BINSH \!=/d" mk/hdr.mk || die #335083
	sed -i -e 's/-lXext/& -lXrender -lX11/' cmd/Makefile || die #369115
}

src_configure() {
	append-flags -fcommon
	default
}

src_compile() {
	append-flags -I/usr/include/freetype2
	emake "${mywmiiconf[@]}"
}

src_install() {
	emake "${mywmiiconf[@]}" install

	echo "${PN}" > "${T}/${PN}" || die
	exeinto /etc/X11/Sessions
	doexe "${T}/${PN}"

	insinto /usr/share/xsessions
	doins "${FILESDIR}"/${PN}.desktop
}
