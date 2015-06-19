# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/linuxfromscratch/linuxfromscratch-7.7.ebuild,v 1.1 2015/04/04 21:42:45 rhill Exp $

EAPI=5

MY_SRC="http://www.linuxfromscratch.org/lfs/downloads/${PV}"
BOOTSCRIPT_PV="20150222"

DESCRIPTION="LFS documents building a Linux system entirely from source"
HOMEPAGE="http://www.linuxfromscratch.org/lfs"
SRC_URI="${MY_SRC}/LFS-BOOK-${PV}.tar.bz2
		${MY_SRC}/lfs-bootscripts-${BOOTSCRIPT_PV}.tar.bz2
		htmlsingle? ( ${MY_SRC}/LFS-BOOK-${PV}-NOCHUNKS.html )
		pdf? ( ${MY_SRC}/LFS-BOOK-${PV}.pdf )"

LICENSE="CC-BY-NC-SA-2.5 MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="htmlsingle pdf"

DEPEND=""
RDEPEND=""

S=${WORKDIR}

src_unpack() {
	unpack LFS-BOOK-${PV}.tar.bz2 \
		lfs-bootscripts-${BOOTSCRIPT_PV}.tar.bz2

	use htmlsingle && cp "${DISTDIR}"/LFS-BOOK-${PV}-NOCHUNKS.html "${S}"
	use pdf && cp "${DISTDIR}"/LFS-BOOK-${PV}.pdf "${S}"
}

src_install() {
	dodoc -r *
	docompress -x /usr/share/doc/${PF}
}
