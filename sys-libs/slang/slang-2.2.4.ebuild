# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/slang/slang-2.2.4.ebuild,v 1.14 2013/11/19 12:41:59 slyfox Exp $

EAPI=4
inherit eutils

DESCRIPTION="A multi-platform programmer's library designed to allow a developer to create robust software"
HOMEPAGE="http://www.jedsoft.org/slang/"
SRC_URI="mirror://slang/v${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x86-solaris"
IUSE="cjk pcre png readline static-libs zlib"

# ncurses for ncurses5-config to get terminfo directory
RDEPEND="sys-libs/ncurses
	pcre? ( dev-libs/libpcre )
	png? ( >=media-libs/libpng-1.2:0 )
	cjk? ( dev-libs/oniguruma )
	readline? ( sys-libs/readline )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.2.3-slsh-libs.patch
	epatch "${FILESDIR}"/${PN}-2.2.4-memset.patch

	# avoid linking to -ltermcap race with some systems
	sed -i -e '/^TERMCAP=/s:=.*:=:' configure || die
	# we use the GNU linker also on Solaris
	sed -i -e 's/-G -fPIC/-shared -fPIC/g' \
		-e 's/-Wl,-h,/-Wl,-soname,/g' configure || die
}

src_configure() {
	local myconf=slang
	use readline && myconf=gnu

	econf \
		--with-readline=${myconf} \
		$(use_with pcre) \
		$(use_with cjk onig) \
		$(use_with png) \
		$(use_with zlib z)
}

src_compile() {
	emake elf $(use static-libs && echo static)

	pushd slsh >/dev/null
	emake slsh
	popd
}

src_install() {
	emake DESTDIR="${D}" install $(use static-libs && echo install-static)

	rm -rf "${ED}"/usr/share/doc/{slang,slsh}

	dodoc NEWS README *.txt doc/{,internal,text}/*.txt
	dohtml doc/slangdoc.html slsh/doc/html/*.html
}
