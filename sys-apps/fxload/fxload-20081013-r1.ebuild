# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/fxload/fxload-20081013-r1.ebuild,v 1.8 2014/01/15 09:55:50 ago Exp $

EAPI=5

inherit eutils toolchain-funcs

# source maintainers named it fxload-YYYY_MM_DD instead of fxload-YYYYMMDD
MY_P="${PN}-${PV:0:4}_${PV:4:2}_${PV:6:2}"
DESCRIPTION="USB firmware uploader"
HOMEPAGE="http://linux-hotplug.sourceforge.net/"
SRC_URI="mirror://sourceforge/linux-hotplug/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i \
		-e 's:$(CC) -o:$(CC) $(LDFLAGS) -o:' \
		Makefile || die
}

src_compile() {
	tc-export CC
	emake RPM_OPT_FLAGS="${CFLAGS}"
}

src_install() {
	emake prefix="${D}" install
	dodoc README.txt
}
