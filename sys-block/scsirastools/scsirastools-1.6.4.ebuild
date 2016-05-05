# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit autotools eutils

DESCRIPTION="Serviceability for SCSI Disks and Arrays"
HOMEPAGE="http://scsirastools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="sys-apps/rescan-scsi-bus
	sys-apps/sg3_utils"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.5.7-sysmacros.patch #580214
	# this builds a really old mdadm
	sed -i \
		-e '/RPMB/d' \
		-e '/^SUBDIRS/s,mdadm.d,,' \
		-e '/^SUBDIRS/s,files,,' \
		Makefile.am || die "sed Makefile.am failed"
	eautoreconf
	# i386 ELF binaries in tarball = bad
	rm "${S}"/files/ialarms* || die

	# Fix up /sbin instances to be /usr/sbin instead
	for i in src/sgraidmon.c src/sgdiskmon.c ; do
		sed -i "${S}"/${i} \
			-e '/evtcmd\[\].*\"\/sbin\//s,/sbin/,/usr/sbin/,' \
			|| die "Failed to set /sbin in sources"
	done
}

src_configure() {
	econf --sbindir=/usr/sbin
}

src_install() {
	local docdir="/usr/share/doc/${PF}"
	emake install DESTDIR="${D}" datato="${ED}${docdir}"
	dosbin files/sgevt files/mdevt
	rm -f "${ED}${docdir}"/{SCSIRAS,COPYING}
	# install modepage files
	insinto /usr/share/${PN}
	doins files/*.mdf
	dodoc ChangeLog AUTHORS TODO
}
