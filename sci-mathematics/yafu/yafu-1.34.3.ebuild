# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils versionator

MY_PV="$(get_version_component_range 1-2)"

DESCRIPTION="Yet another factoring utility"
HOMEPAGE="https://sourceforge.net/projects/yafu/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PV}/${PN}-${MY_PV}-src.zip"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="~amd64 ~x86"
# nfs is overloaded, so using less confusing sieve here
IUSE="+sieve"

DEPEND="
	dev-libs/gmp:0=
	sci-mathematics/gmp-ecm
	sieve? (
		sci-mathematics/msieve
		sci-mathematics/ggnfs )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/fix-Makefile.patch"
	# This is not nice. But then the Makefile is quite special :)
	sed -i -e 's:../gmp/include:gmp:' Makefile 		|| die "Failed to rectify things"
	sed -i -e 's:../gmp-ecm/include:gmp-ecm:' Makefile 	|| die "Failed to rectify things"
	sed -i -e 's:LIBS += -L../:# LIBS += -L../:g' Makefile	|| die "Failed to rectify things"
	sed -i -e 's:\"config.h\":<gmp-ecm/config.h>:g' top/driver.c	|| die "Failed to rectify things"
	sed -i -e 's:# LIBS += -L../msieve/lib/linux/x86_64:LIBS += -lmsieve -lz -ldl:' Makefile	|| die "Failed to rectify things"
	sed -i -e 's:CFLAGS = -g:#CFLAGS = -g:' Makefile	|| die "Failed to rectify things"
	sed -i -e '/$(LIBS)$/s:$(CC):$(CC) $(LDFLAGS):g' Makefile || die

	# proper ggnfs default path
	sed -i -e 's~strcpy(fobj->nfs_obj.ggnfs_dir,"./");~strcpy(fobj->nfs_obj.ggnfs_dir,"/usr/bin/");~' factor/factor_common.c || die "Failed to rectify things"
}

src_compile() {
	local VAR=""
	# hmm, not that useful:
	#VAR="TIMING=1 "
	use sieve && VAR+="NFS=1"
	use amd64 && emake $VAR x86_64
	use x86 && emake $VAR x86
}

src_install() {
	dobin "${S}/yafu"
	dodoc docfile.txt README yafu.ini
}
