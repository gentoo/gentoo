# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils autotools
if [[ ${PV} == "9999" ]] ; then
	ESVN_REPO_URI="svn://svn.savannah.gnu.org/nano/trunk/nano"
	inherit subversion autotools
else
	MY_P=${PN}-${PV/_}
	SRC_URI="http://www.nano-editor.org/dist/v${PV:0:3}/${MY_P}.tar.gz"
fi

DESCRIPTION="GNU GPL'd Pico clone with more functionality"
HOMEPAGE="http://www.nano-editor.org/ https://www.gentoo.org/doc/en/nano-basics-guide.xml"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug justify +magic minimal ncurses nls slang spell unicode"

RDEPEND=">=sys-libs/ncurses-5.9-r1[unicode?]
	magic? ( sys-apps/file )
	nls? ( virtual/libintl )
	!ncurses? ( slang? ( sys-libs/slang ) )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.3.1-drop-target.patch
	epatch "${FILESDIR}"/${PN}-2.3.1-ncurses-pkg-config.patch
	epatch "${FILESDIR}"/${PN}-2.3.1-bind-unbind-docs.patch
	epatch "${FILESDIR}"/${PN}-2.3.1-{shell,gentoo}-nanorc.patch
	eautoreconf
}

src_configure() {
	eval export ac_cv_{header_magic_h,lib_magic_magic_open}=$(usex magic)
	econf \
		--bindir="${EPREFIX}"/bin \
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
		$(usex ncurses --without-slang $(use_with slang))
}

src_install() {
	emake DESTDIR="${D}" install || die
	rm -rf "${ED}"/usr/share/nano/man-html

	dodoc ChangeLog README doc/nanorc.sample AUTHORS BUGS NEWS TODO
	dohtml doc/faq.html
	insinto /etc
	newins doc/nanorc.sample nanorc

	dodir /usr/bin
	dosym /bin/nano /usr/bin/nano
}
