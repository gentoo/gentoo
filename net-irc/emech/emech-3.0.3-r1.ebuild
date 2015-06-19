# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/emech/emech-3.0.3-r1.ebuild,v 1.4 2014/06/11 09:00:22 zlogene Exp $

EAPI=5

inherit eutils readme.gentoo toolchain-funcs

DESCRIPTION="UNIX compatible IRC bot programmed in the C language"
HOMEPAGE="http://www.energymech.net/"
SRC_URI="http://www.energymech.net/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE="debug session tcl"

DOC_CONTENTS="You can find a compressed sample config file at /usr/share/doc/${PF}"

src_prepare() {
	sed -i \
		-e 's: "help/":"/usr/share/energymech/help/":' \
		-e 's: "messages/":"/usr/share/energymech/messages/":' \
		src/config.h.in || die
	# Respect CFLAGS and LDFLAGS
	sed -i \
		-e '/^LFLAGS/s/\$(PIPEFLAG)/\0 \$(OPTIMIZE) \$(LDFLAGS)/' \
		-e '/^GDBFLAG/d' \
		-e '/^PIPEFLAG/d' \
		src/Makefile.in || die

	epatch_user
}

myconf() {
	echo ./configure $*
	./configure $* || die "./configure failed"
}

src_configure() {
	myconf \
		--with-alias \
		--with-botnet \
		--with-bounce \
		--with-ctcp \
		--with-dccfile \
		--with-dynamode \
		--with-dyncmd \
		--with-greet \
		--with-ircd_ext \
		--with-md5 \
		--with-newbie \
		--with-note \
		--with-notify \
		--with-rawdns \
		--with-redirect \
		--with-seen \
		--with-stats \
		--with-telnet \
		--with-toybox \
		--with-trivia \
		--without-uptime \
		--with-web \
		--with-wingate \
		--without-profiling \
		$(use_with tcl) \
		$(use_with session) \
		$(use_with debug)
}

src_compile() {
	emake -C src CC="$(tc-getCC)" OPTIMIZE="${CFLAGS}"
}

src_install() {
	dobin src/energymech

	insinto /usr/share/energymech
	doins -r help

	insinto /usr/share/energymech/messages
	doins messages/*.txt

	dodoc sample.* README* TODO VERSIONS CREDITS checkmech
	readme.gentoo_create_doc
}
