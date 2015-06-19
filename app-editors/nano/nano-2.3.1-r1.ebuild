# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/nano/nano-2.3.1-r1.ebuild,v 1.12 2012/07/29 16:52:55 armin76 Exp $

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
HOMEPAGE="http://www.nano-editor.org/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug justify minimal ncurses nls slang spell unicode"

RDEPEND=">=sys-libs/ncurses-5.9-r1[unicode?]
	nls? ( sys-devel/gettext )
	!ncurses? ( slang? ( sys-libs/slang ) )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.3.1-ncurses-pkg-config.patch
	eautoreconf
}

src_configure() {
	local myconf=""
	use ncurses \
		&& myconf="--without-slang" \
		|| myconf="${myconf} $(use_with slang)"

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
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc ChangeLog README doc/nanorc.sample AUTHORS BUGS NEWS TODO
	dohtml doc/faq.html
	insinto /etc
	newins doc/nanorc.sample nanorc

	dodir /usr/bin
	dosym /bin/nano /usr/bin/nano
}

pkg_postinst() {
	einfo "More helpful info about nano, visit the GDP page:"
	einfo "http://www.gentoo.org/doc/en/nano-basics-guide.xml"
}
