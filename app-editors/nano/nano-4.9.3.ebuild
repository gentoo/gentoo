# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.sv.gnu.org/nano.git"
	inherit git-r3 autotools
else
	MY_P="${PN}-${PV/_}"
	SRC_URI="https://www.nano-editor.org/dist/v${PV:0:1}/${MY_P}.tar.gz"
	KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="GNU GPL'd Pico clone with more functionality"
HOMEPAGE="https://www.nano-editor.org/ https://wiki.gentoo.org/wiki/Nano/Basics_Guide"

LICENSE="GPL-3"
SLOT="0"
IUSE="debug justify +magic minimal ncurses nls slang +spell +split-usr static unicode"

LIB_DEPEND=">=sys-libs/ncurses-5.9-r1:0=[unicode?]
	sys-libs/ncurses:0=[static-libs(+)]
	magic? ( sys-apps/file[static-libs(+)] )
	nls? ( virtual/libintl )
	!ncurses? ( slang? ( sys-libs/slang[static-libs(+)] ) )"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )"
BDEPEND="
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"
src_prepare() {
	default
	if [[ ${PV} == "9999" ]] ; then
		eautoreconf
	fi
}

src_configure() {
	use static && append-ldflags -static
	local myconf=(
		--bindir="${EPREFIX}"/bin
		--htmldir=/trash
		$(use_enable !minimal color)
		$(use_enable !minimal multibuffer)
		$(use_enable !minimal nanorc)
		$(use_enable magic libmagic)
		$(use_enable spell speller)
		$(use_enable justify)
		$(use_enable debug)
		$(use_enable nls)
		$(use_enable unicode utf8)
		$(use_enable minimal tiny)
		$(usex ncurses --without-slang $(use_with slang))
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	# don't use "${ED}" here or things break (#654534)
	rm -r "${D}"/trash || die

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

	use split-usr && dosym ../../bin/nano /usr/bin/nano
}
