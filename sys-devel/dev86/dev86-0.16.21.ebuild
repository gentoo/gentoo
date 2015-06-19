# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/dev86/dev86-0.16.21.ebuild,v 1.1 2014/06/12 12:36:34 polynomial-c Exp $

EAPI="5"

inherit eutils multilib

DESCRIPTION="Bruce's C compiler - Simple C compiler to generate 8086 code"
HOMEPAGE="http://v3.sk/~lkundrak/dev86/"
SRC_URI="http://v3.sk/~lkundrak/dev86/Dev86src-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="sys-devel/bin86"
DEPEND="${RDEPEND}
	dev-util/gperf"

STRIP_MASK="/usr/*/bcc/lib*.a /usr/*/i386/libc.a"

src_prepare() {
	# elksemu doesn't compile under amd64
	if use amd64; then
		einfo "Not compiling elksemu on amd64"
		sed -i \
			-e 's,alt-libs elksemu,alt-libs,' \
			-e 's,install-lib install-emu,install-lib,' \
			makefile.in || die
	fi

	epatch "${FILESDIR}"/dev86-pic.patch
	epatch "${FILESDIR}"/${PN}-0.16.19-fortify.patch
	sed -i \
		-e "s:-O2 -g:${CFLAGS}:" \
		-e '/INEXE=/s:-s::' \
		makefile.in || die
	sed -i \
		-e "s:/lib/:/$(get_libdir)/:" \
		bcc/bcc.c || die
	sed -i -e '/INSTALL_OPTS=/s:-s::' bin86/Makefile || die
	sed -i -e '/install -m 755 -s/s:-s::' dis88/Makefile || die
}

src_compile() {
	# Don't mess with CPPFLAGS as they tend to break compilation
	# (bug #343655).
	CPPFLAGS=""

	# First `make` is also a config, so set all the path vars here
	emake -j1 \
		DIST="${D}" \
		CC="$(tc-getCC)" \
		LIBDIR="/usr/$(get_libdir)/bcc" \
		INCLDIR="/usr/$(get_libdir)/bcc"

	export PATH=${S}/bin:${PATH}
	cd bin
	ln -s ncc bcc
	cd ..
	cd bootblocks
	ln -s ../bcc/version.h .
	emake DIST="${D}"
}

src_install() {
	emake -j1 install-all DIST="${D}"
	dobin bootblocks/makeboot
	# remove all the stuff supplied by bin86
	cd "${D}"
	rm usr/bin/{as,ld,nm,objdump,size}86 || die
	rm usr/man/man1/{as,ld}86.1 || die
	dodir /usr/share/man
	mv usr/man usr/share/
}
