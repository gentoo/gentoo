# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils
if [[ ${PV} == "9999" ]] ; then
	ESVN_REPO_URI="svn://svn.savannah.gnu.org/nano/trunk/nano"
	inherit subversion autotools
else
	MY_P=${PN}-${PV/_}
	SRC_URI="http://www.nano-editor.org/dist/v${PV:0:3}/${MY_P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="GNU GPL'd Pico clone with more functionality"
HOMEPAGE="http://www.nano-editor.org/ https://wiki.gentoo.org/wiki/Nano/Basics_Guide"

LICENSE="GPL-3"
SLOT="0"
IUSE="debug justify +magic minimal ncurses nls slang +spell unicode"

RDEPEND=">=sys-libs/ncurses-5.9-r1[unicode?]
	magic? ( sys-apps/file )
	nls? ( virtual/libintl )
	!ncurses? ( slang? ( sys-libs/slang ) )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		eautoreconf
	fi
	epatch_user
}

src_configure() {
	eval export ac_cv_{header_magic_h,lib_magic_magic_open}=$(usex magic)
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

	dodoc doc/nanorc.sample
	dohtml doc/faq.html
	insinto /etc
	newins doc/nanorc.sample nanorc
	if ! use minimal ; then
		# Enable colorization by default.
		sed -i \
			-e '/^# include /s:# *::' \
			"${ED}"/etc/nanorc || die
	fi

	dodir /usr/bin
	dosym /bin/nano /usr/bin/nano
}
