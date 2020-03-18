# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools multilib-minimal

DESCRIPTION="LAME Ain't an MP3 Encoder"
HOMEPAGE="http://lame.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="debug cpu_flags_x86_mmx +frontend mp3rtp sndfile static-libs"

# These deps are without MULTILIB_USEDEP and are correct since we only build
# libmp3lame for multilib and these deps apply to the lame frontend executable.
RDEPEND="
	frontend? (
		>=sys-libs/ncurses-5.7-r7:0=
		sndfile? ( >=media-libs/libsndfile-1.0.2 )
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	cpu_flags_x86_mmx? ( dev-lang/nasm )
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.96-ccc.patch
	"${FILESDIR}"/${PN}-3.98-gtk-path.patch
	"${FILESDIR}"/${PN}-3.99.5-tinfo.patch
	"${FILESDIR}"/${PN}-3.99.5-msse.patch
	"${FILESDIR}"/${PN}-3.100-symbols.patch #662752
)

src_prepare() {
	default

	mkdir libmp3lame/i386/.libs || die #workaround parallel build with nasm

	sed -i -e '/define sp/s/+/ + /g' libmp3lame/i386/nasm.h || die

	use cpu_flags_x86_mmx || sed -i -e '/AC_PATH_PROG/s:nasm:dIsAbLe&:' configure.in #361879

	mv configure.{in,ac} || die
	AT_M4DIR=. eautoreconf
}

multilib_src_configure() {
	# Only build the frontend for the default ABI.
	local myconf=(
		--disable-mp3x
		--enable-dynamic-frontends
		$(multilib_native_use_enable frontend)
		$(multilib_native_use_enable mp3rtp)
		$(multilib_native_usex sndfile '--with-fileio=sndfile' '')
		$(use_enable debug debug norm)
		$(use_enable static-libs static)
		$(usex cpu_flags_x86_mmx '--enable-nasm' '') #361879
	)

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install() {
	emake \
		DESTDIR="${D}" \
		pkghtmldir="${EPREFIX}/usr/share/doc/${PF}/html" \
		install
}

multilib_src_install_all() {
	dodoc API ChangeLog HACKING README STYLEGUIDE TODO USAGE
	docinto html
	dodoc misc/lameGUI.html Dll/LameDLLInterface.htm

	find "${D}" -name '*.la' -type f -delete || die
}
