# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

MY_P=${P/4.1.1/4.1}
DESCRIPTION="Linux Kernel Crash Dumps (LKCD) Utilities"
HOMEPAGE="http://lkcd.sourceforge.net/ http://oss.software.ibm.com/developerworks/opensource/linux390/june2003_recommended.shtml"
SRC_URI="http://lkcd.sourceforge.net/download/OLD/4.1.1/lkcdutils/lkcdutils-4.1-1.src.rpm
	mirror://gentoo/lkcdutils-4.1-savedump.tar.gz
	mirror://gentoo/lkcdutils-4.1-dhv8.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="s390"
IUSE=""

DEPEND="app-arch/rpm2targz
	dev-util/byacc"
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	ebegin "Unpacking lkcd distribution..."
	# This is the same as using rpm2targz then extracting 'cept that
	 # it's faster, less work, and less hard disk space.  rpmoffset is
	# provided by the rpm2targz package.
	i="${DISTDIR}/${PN}-4.1-1.src.rpm"
	dd ibs=`rpmoffset < ${i}` skip=1 if=$i 2>/dev/null \
	| gzip -dc | cpio -idmu 2>/dev/null && tar xzf ${PN}-4.1-1.tar.gz
	eend ${?}
	assert "Failed to extract lkcd distribution..."

	unpack lkcdutils-4.1-savedump.tar.gz
	unpack lkcdutils-4.1-dhv8.tar.gz
	cd "${S}"
	epatch ../lkcdutils-4.1-savedump.diff
	epatch ../lkcdutils-4.1-dhv8.diff
}

src_compile() {
	./configure \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--datadir=/usr/share \
		--sysconfdir=/etc \
		 --bfd_version=2.14.90 || die "configure failed"

	make || die "make failed"
}

src_install() {
	make install ROOT="${D}" || die "install failed"
	# not needed on s390
	rm -rf "${D}"/usr/share/sial \
		"${D}"/usr/lib/libsial.a \
		"${D}"/usr/include/sial_api.h \
		"${D}"/usr/include/lkcd/asm/lc_dis.h \
		"${D}"/etc \
		"${D}"/sbin/lkcd* \
		"${D}"/usr/man/man/lkcd*
	# broken configure script...
	mv -f "${D}"/usr/man "${D}"/usr/share/man
}
