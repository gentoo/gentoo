# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
DESCRIPTION="Modern, high-level, general-purpose, high-performance programming language"
HOMEPAGE="http://jsoftware.com"
SRC_URI="http://www.jsoftware.com/download/${PN}${PV}_b_source.tar.gz"

inherit eutils

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/jgplsrc"

src_prepare() {
	sed -i -e 's:make libj >& make.txt:make libj:' bin/build_libj || die
	sed -i -e 's:W1,soname:Wl,-soname:' bin/jconfig || die
	if use amd64; then
		sed -i -e 's/bits=32/bits=64/' bin/jconfig || die
	fi
}

src_compile() {
	bin/jconfig	|| die
	bin/build_defs 	|| die
	bin/build_libj 	|| die
	bin/build_jconsole || die
}

src_install() {
	# since this appears to use hardcoded relative paths
	# there's no sane way to put it in the normal filesystem hierarchy
	mkdir -p "${D}/opt/j"
	cp -r j/* "${D}/opt/j" || die
	mkdir -p "${D}/usr/bin"
	echo -e "#!/bin/sh\n/opt/j/bin/jconsole" > "${D}/usr/bin/jc"  || die
	chmod +x "${D}/usr/bin/jc"
}
