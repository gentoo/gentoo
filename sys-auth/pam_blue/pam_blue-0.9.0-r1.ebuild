# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools pam

DESCRIPTION="PAM module providing ability to authenticate via a bluetooth compatible device"
HOMEPAGE="http://pam.0xdef.net/"
SRC_URI="http://pam.0xdef.net/source/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/pam
	net-wireless/bluez"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}-char-locales.patch #412941
	eapply "${FILESDIR}"/${P}-bad-log.patch
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf --libdir="$(getpam_mod_dir)"
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
