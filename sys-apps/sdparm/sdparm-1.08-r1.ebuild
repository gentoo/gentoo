# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/sdparm/sdparm-1.08-r1.ebuild,v 1.3 2014/10/17 01:43:23 vapier Exp $

EAPI="4"

DESCRIPTION="Utility to output and modify parameters on a SCSI device, like hdparm"
HOMEPAGE="http://sg.danny.cz/sg/sdparm.html"
SRC_URI="http://sg.danny.cz/sg/p/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE=""

# Older releases contain a conflicting sas_disk_blink
RDEPEND=">=sys-apps/sg3_utils-1.28"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog CREDITS README notes.txt )

src_configure() {
	# sdparm ships with a local copy of this lib, but will use the system copy if it
	# detects it (see the README file).  Force the use of the system lib.  #479578
	export ac_cv_lib_sgutils2_sg_ll_inquiry=yes
	default
}

src_install() {
	default

	# These don't exist yet. Someone wanna copy hdparm's and make them work? :)
	#newinitd ${FILESDIR}/sdparm-init-7 sdparm
	#newconfd ${FILESDIR}/sdparm-conf.d.3 sdparm
}
