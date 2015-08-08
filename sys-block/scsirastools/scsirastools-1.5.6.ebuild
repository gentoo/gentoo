# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit autotools eutils

DESCRIPTION="Serviceability for SCSI Disks and Arrays"
HOMEPAGE="http://scsirastools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

RDEPEND="sys-apps/rescan-scsi-bus
	sys-apps/sg3_utils"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	# this builds a really old mdadm
	sed -i \
		-e '/RPMB/d' \
		-e '/^SUBDIRS/s,mdadm.d,,' \
		-e '/^SUBDIRS/s,files,,' \
		"${S}"/Makefile.am || die "sed Makefile.am failed"
	cd "${S}"
	epatch "${FILESDIR}"/${P}-glibc-2.10.patch
	eautoreconf
	# i386 ELF binaries in tarball = bad
	rm -f "${S}"/files/alarms*

	# Fix up /sbin instances to be /usr/sbin instead
	for i in src/sgraidmon.c src/sgdiskmon.c ; do
		sed -i "${S}"/${i} \
			-e '/evtcmd\[\].*\"\/sbin\//s,/sbin/,/usr/sbin/,' \
			|| die "Failed to set /sbin in sources"
	done
}

src_compile() {
	econf --sbindir=/usr/sbin \
		|| die "econf failed"
	emake \
		|| die "emake failed"
}

src_install() {
	into /usr
	docdir="/usr/share/doc/${PF}/"
	emake install DESTDIR="${D}" datato="${D}${docdir}" \
		|| die "emake install failed"
	dosbin files/sgevt
	dosbin files/mdevt
	# unneeded files
	rm -f "${D}"${docdir}/{SCSIRAS,COPYING}
	# install modepage files
	insinto /usr/share/${PN}
	doins files/*.mdf
	# new docs
	dodoc ChangeLog AUTHORS TODO
	# ensure that other docs from the emake install are compressed too.
	prepalldocs
}
