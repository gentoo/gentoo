# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils flag-o-matic
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.sv.gnu.org/nano.git"
	inherit git-r3 autotools
else
	MY_P=${PN}-${PV/_}
	SRC_URI="https://www.nano-editor.org/dist/v${PV:0:3}/${MY_P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="GNU GPL'd Pico clone with more functionality"
HOMEPAGE="https://www.nano-editor.org/ https://wiki.gentoo.org/wiki/Nano/Basics_Guide"

LICENSE="GPL-3"
SLOT="0"
IUSE="debug justify +magic minimal ncurses nls slang +spell static unicode"

LIB_DEPEND=">=sys-libs/ncurses-5.9-r1:0=[unicode?]
	sys-libs/ncurses:0=[static-libs(+)]
	magic? ( sys-apps/file[static-libs(+)] )
	nls? ( virtual/libintl )
	!ncurses? ( slang? ( sys-libs/slang[static-libs(+)] ) )"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
	static? ( ${LIB_DEPEND} )"

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		eautoreconf
	fi
	default
}

src_configure() {
	use static && append-ldflags -static
	local myconf=()
	case ${CHOST} in
	*-gnu*|*-uclibc*) myconf+=( "--with-wordbounds" ) ;; #467848
	esac
	econf \
		--bindir="${EPREFIX}"/bin \
		--htmldir=/trash \
		$(use_enable !minimal color) \
		$(use_enable !minimal multibuffer) \
		$(use_enable !minimal nanorc) \
		--disable-wrapping-as-root \
		$(use_enable magic libmagic) \
		$(use_enable spell speller) \
		$(use_enable justify) \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable unicode utf8) \
		$(use_enable minimal tiny) \
		$(usex ncurses --without-slang $(use_with slang)) \
		"${myconf[@]}"
}

src_install() {
	default
	rm -rf "${D}"/trash

	dodoc doc/sample.nanorc
	docinto html
	dodoc doc/faq.html
	insinto /etc
	newins doc/sample.nanorc nanorc
	if ! use minimal ; then
		# Enable colorization by default.
		sed -i \
			-e '/^# include /s:# *::' \
			"${ED}"/etc/nanorc || die
	fi

	dodir /usr/bin
	dosym /bin/nano /usr/bin/nano
}
