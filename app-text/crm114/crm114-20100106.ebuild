# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/crm114/crm114-20100106.ebuild,v 1.6 2012/03/06 14:29:46 ranger Exp $

EAPI=2

MY_P="${P}-BlameMichelson.src"

inherit eutils toolchain-funcs

DESCRIPTION="A powerful text processing tool, mainly used for spam filtering"
HOMEPAGE="http://crm114.sourceforge.net/"
SRC_URI="http://crm114.sourceforge.net/tarballs/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE="mew mimencode nls normalizemime static test"

RDEPEND="
	static? ( dev-libs/tre[static-libs] )
	!static? ( dev-libs/tre )
	mew? ( app-emacs/mew )
	mimencode? ( net-mail/metamail )
	normalizemime? ( mail-filter/normalizemime )"
DEPEND="${RDEPEND}
	test? ( sys-apps/miscfiles )"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	sed \
		-e "s#-O3 -Wall##" \
		-e "s#^CC=.*#CC=$(tc-getCC)#" \
		-i Makefile || die
	# Upstream recommends static linking
	if ! use static ; then
		sed -i "s#LDFLAGS += -static -static-libgcc#LDFLAGS += ${LDFLAGS}#" Makefile || die
	else
		sed \
			-e "s#LDFLAGS += -static -static-libgcc#LDFLAGS += ${LDFLAGS} -static -static-libgcc#" \
			-i Makefile || die
	fi

	if use mimencode ; then
		sed \
			-e 's%#:mime_decoder: /mimencode -u/%:mime_decoder: /mimencode -u/%' \
			-e 's%:mime_decoder: /mewdecode/%#:mime_decoder: /mewdecode/%' \
			-i mailfilter.cf || die
	elif use normalizemime ; then
		sed \
			-e 's%#:mime_decoder: /normalizemime/%:mime_decoder: /normalizemime/%' \
			-e 's%:mime_decoder: /mewdecode/%#:mime_decoder: /mewdecode/%' \
			-i mailfilter.cf || die
	fi

}

src_install() {
	dobin crm114 cssutil cssdiff cssmerge || die
	dobin cssutil cssdiff cssmerge || die
	dobin osbf-util || die

	dodoc COLOPHON.txt CRM114_Mailfilter_HOWTO.txt FAQ.txt INTRO.txt || die
	dodoc QUICKREF.txt CLASSIFY_DETAILS.txt inoc_passwd.txt || die
	dodoc KNOWNBUGS.txt THINGS_TO_DO.txt README || die
	docinto examples
	dodoc *.example || die

	insinto /usr/share/${PN}
	doins *.crm || die
	doins *.cf || die
	doins *.mfp || die
}

src_test() {
	emake megatest || die
}

pkg_postinst() {
	elog "The spam-filter CRM files are installed in /usr/share/${PN}."
}
