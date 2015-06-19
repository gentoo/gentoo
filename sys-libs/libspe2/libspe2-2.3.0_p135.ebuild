# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libspe2/libspe2-2.3.0_p135.ebuild,v 1.3 2015/02/27 08:09:09 vapier Exp $
inherit eutils

MY_P=${P/_p/.}

DESCRIPTION="A wrapper library to adapt the JSRE SPU usage model to SPUFS"
HOMEPAGE="http://sourceforge.net/projects/libspe"
SRC_URI="mirror://sourceforge/libspe/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~ppc ~ppc64"
IUSE="debug"

S="${WORKDIR}/${P/_p*//}"

DEPEND=""
# This packages also provides libspe1
RDEPEND="!sys-libs/libspe"

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

if [[ ${CTARGET} == ${CHOST} ]] ; then
	SYSROOT=""
else
	SYSROOT="/usr/${CTARGET}"
fi

src_unpack () {
	unpack ${A}
	#just in case something is missing
	cd "${S}"
	echo "${S}"
}

src_compile() {
	myconf=""
	use debug && myconf="${myconf} DEBUG=1"
	make all elfspe-all CROSS="${CTARGET}-" \
		prefix=/usr SYSROOT="$SYSROOT" ${myconf} \
		speinclude=/usr/spu-elf/include || die
}

src_install() {
	make CROSS="${CTARGET}-" prefix=/usr \
		 speinclude=/usr/spu-elf/include \
		 SYSROOT="$SYSROOT" \
		 DESTDIR="$D" install elfspe-install || die
	newinitd "${FILESDIR}/spe.rc6" elfspe
}

pkg_postinst() {
	einfo "You may want to register elfspe to binfmt using the"
	einfo "provided initscript"
	einfo "# rc-update add elfspe boot"
	ewarn "make sure your fstab contains the following line"
	ewarn "none                    /spu            spufs           defaults
	0 0"
	ewarn "and that you have spufs support enabled in the kernel"
}
