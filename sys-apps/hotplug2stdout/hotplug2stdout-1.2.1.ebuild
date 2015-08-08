# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="A tool for reading kernel uevent(s) to stdout"
HOMEPAGE="http://www.bellut.net/projects.html"
# wget --user puppy --password linux "http://bkhome.org/sources/alphabetical/h/${P}.tar.gz"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_prepare() { rm -f ${PN}; }
src_compile() { $(tc-getCC) ${LDFLAGS} ${CFLAGS} ${CPPFLAGS} ${PN}.c -o ${PN} || die; }
src_install() { dobin ${PN}; }
