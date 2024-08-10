# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Utility to output and modify parameters on a SCSI device, like hdparm"
HOMEPAGE="http://sg.danny.cz/sg/sdparm.html"
SRC_URI="http://sg.danny.cz/sg/p/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

# Older releases contain a conflicting sas_disk_blink
RDEPEND=">=sys-apps/sg3_utils-1.45:0="
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
	#newinitd ${FILESDIR}/sdparm-init-1 sdparm
	#newconfd ${FILESDIR}/sdparm-conf.d-1 sdparm
}
