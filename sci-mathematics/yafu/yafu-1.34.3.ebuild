# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

MY_PV="$(ver_cut 1-2)"
DESCRIPTION="Yet another factoring utility"
HOMEPAGE="https://sourceforge.net/projects/yafu/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PV}/${PN}-${MY_PV}-src.zip"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="~amd64 ~x86"
IUSE="+sieve"

DEPEND="
	dev-libs/gmp:0=
	sci-mathematics/gmp-ecm
	sieve? (
		sci-mathematics/ggnfs
		sci-mathematics/msieve
	)"
RDEPEND="${DEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=( "${FILESDIR}"/${P}-Makefile.patch )

src_prepare() {
	default
	sed -i \
		-e 's:../gmp/include:gmp:' \
		-e 's:../gmp-ecm/include:gmp-ecm:' \
		-e 's:# LIBS += -L../msieve/lib/linux/x86_64:LIBS += -lmsieve -lz -ldl:' \
		-e 's:CFLAGS = -g:#CFLAGS = -g:' \
		-e '/$(LIBS)$/s:$(CC):$(CC) $(LDFLAGS):g' Makefile || die
	sed -i -e 's:\"config.h\":<gmp-ecm/config.h>:g' top/driver.c || die

	# proper ggnfs default path
	sed -i -e 's~strcpy(fobj->nfs_obj.ggnfs_dir,"./");~strcpy(fobj->nfs_obj.ggnfs_dir,"/usr/bin/");~' factor/factor_common.c || die
}

src_configure() {
	append-cflags -fcommon
	default
}

src_compile() {
	local VAR
	use sieve && VAR="NFS=1"
	use amd64 && emake $VAR x86_64
	use x86 && emake $VAR x86
}

src_install() {
	dobin "${S}"/yafu
	dodoc docfile.txt README yafu.ini
}
