# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/hotplug2stdout/hotplug2stdout-1.2.1.ebuild,v 1.3 2013/07/17 08:47:15 ssuominen Exp $

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
