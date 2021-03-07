# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit readme.gentoo-r1 toolchain-funcs

DESCRIPTION="UNIX compatible IRC bot programmed in the C language"
HOMEPAGE="http://www.energymech.net/"
SRC_URI="http://www.energymech.net/files/${P/_/}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE="debug session tcl"
S="${WORKDIR}/${P/_/}"

DOC_CONTENTS="You can find a compressed sample config file at /usr/share/doc/${PF}"

src_prepare() {
	eapply "${FILESDIR}/${P}-buildfix.patch"

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

	eapply_user
}

myconf() {
	tc-export CC
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
		--with-seen \
		--with-stats \
		--with-telnet \
		--with-toybox \
		--with-trivia \
		--without-uptime \
		--with-web \
		--with-wingate \
		--without-profiling \
		--without-redirect \
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
