# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit pam autotools multilib

DESCRIPTION="PAM module providing ability to authenticate via a bluetooth compatible device"
HOMEPAGE="http://pam.0xdef.net/"
SRC_URI="http://pam.0xdef.net/source/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/pam
	net-wireless/bluez"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	eautoreconf
}

src_compile() {
	econf --libdir="$(getpam_mod_dir)"
	emake || die "emake failed"
}

src_install() {
	# manual install to avoid sandbox violation and installing useless .la file
	dopammod src/.libs/pam_blue.so
	newpamsecurity . data/sample.conf bluesscan.conf.sample

	dodoc AUTHORS NEWS README ChangeLog
	doman doc/${PN}.7
}

pkg_postinst() {
	elog "For configuration info, see /etc/security/bluesscan.conf.sample"
	elog "http://pam.0xdef.net/doc.html and http://pam.0xdef.net/faq.html"
	elog "Edit the file as required and copy/rename to bluesscan.conf when done."
}
