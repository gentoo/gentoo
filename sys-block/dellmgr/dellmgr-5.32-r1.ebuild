# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit multilib rpm

MY_PV=${PV}-0
DESCRIPTION="Dell PERC 2/3/4 RAID controller management tool"
HOMEPAGE="http://linux.dell.com/"
SRC_URI="http://ftp.us.dell.com/scsi-raid/perc-apps-A08.tar.gz"

LICENSE="Dell"
SLOT="0"
# This package can never enter stable, it can't be mirrored and upstream
# can remove the distfiles from their mirror anytime.
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="strip mirror test"

S="${WORKDIR}"

pkg_setup() {
	use amd64 && { has_multilib_profile || die "needs multilib profile on amd64"; }
}

src_unpack() {
	unpack ${A}
	rpm_unpack "${S}"/Dellmgr-${MY_PV}.i386.rpm || die "failed to unpack RPM"
}

src_compile() {
	echo "Nothing to compile."
}

src_install() {
	newsbin "${FILESDIR}"/dellmgr-r2 dellmgr
	dosbin usr/sbin/dellmgr.bin
}
