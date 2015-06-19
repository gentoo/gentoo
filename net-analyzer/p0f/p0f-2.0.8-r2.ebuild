# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/p0f/p0f-2.0.8-r2.ebuild,v 1.4 2014/08/10 20:59:56 slyfox Exp $

EAPI="3"

inherit eutils toolchain-funcs

DESCRIPTION="p0f performs passive OS detection based on SYN packets"
HOMEPAGE="http://lcamtuf.coredump.cx/p0f.shtml"
SRC_URI="http://lcamtuf.coredump.cx/p0f/${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="static"

DEPEND="net-libs/libpcap"

S="${WORKDIR}/${PN}"

src_prepare() {
	sed -i p0f.c -e 's;#include <net/bpf.h>;;' || die "sed p0f.c"

	# The first script ensures only p0f is built
	sed -i mk/* \
		-e 's|^\(all: $(FILE)\).*$|\1|' \
		-e 's|^CFLAGS.*=.*|CFLAGS += \\|g' \
		-e '/$(CC).* -o /s|$(CFLAGS)|& $(LDFLAGS)|g' \
		|| die "sed makefiles"

	sed -i Build -e "s|\"/usr/|\"${EPREFIX}/usr/|g" || die "sed Build"

	sed -i config.h \
		-e "s|\"/etc/|\"${EPREFIX}/etc/|g" \
		-e "s|\"/var/|\"${EPREFIX}/var/|g" \
		|| die "sed config.h"
}

src_compile() {
	# Set -j1 to supress a warning that would not be useful in this case
	emake -j1 CC=$(tc-getCC) \
		$(use static && echo static || echo all) p0fq \
		|| die "emake failed"
}

src_install () {
	use static && mv p0f-static p0f
	dosbin p0f p0frep test/p0fq || die

	insinto /etc/p0f
	doins p0f.fp p0fa.fp p0fr.fp

	doman p0f.1 || die
	cd doc
	dodoc ChangeLog CREDITS KNOWN_BUGS README TODO

	newconfd "${FILESDIR}"/${PN}.confd ${PN} || die "newconfd failed"
	newinitd "${FILESDIR}"/${PN}.initd3 ${PN} || die "newinitd failed"
}

pkg_postinst(){
	elog "Adjust /etc/conf.d/p0f to your liking before using the"
	elog "init script. For more information on options, read man p0f."
}
