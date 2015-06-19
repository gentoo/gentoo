# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/tijmp/tijmp-0.8.ebuild,v 1.6 2012/07/06 10:55:32 sera Exp $

EAPI=2

inherit autotools java-pkg-2

DESCRIPTION="Java Memory Profiler for java 1.6+"
HOMEPAGE="http://www.khelekore.org/jmp/tijmp/"
SRC_URI="http://www.khelekore.org/jmp/tijmp/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"

java_prepare() {
	epatch "${FILESDIR}/${PN}-jni.h.patch"
	epatch "${FILESDIR}/${P}-respect-javacflags.patch"
	eautoreconf
}

src_configure() {
	econf --docdir="/usr/share/doc/${PF}"
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" jardir="/usr/share/${PN}/lib/" install || die
	java-pkg_regjar "${D}/usr/share/${PN}/lib/${PN}.jar"
	java-pkg_regso "${D}/usr/$(get_libdir)/lib${PN}.so"

	cat > "${T}/tijmp" <<-"EOF"
		#!/bin/sh
		java -Dtijmp.jar="$(java-config -p tijmp)" -agentlib:tijmp "${@}"
EOF
	dobin "${T}/tijmp"
}

pkg_postinst() {
	einfo "For your convenience, ${PN} wrapper can be used to run java"
	einfo "with profiling. Just use it in place of the 'java' command."
}
