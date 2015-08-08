# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils pam

MY_P=${P/_rc/-rc}

DESCRIPTION="The PAM SMB module, allows authentication against a SMB (such as the Win_x families) server"
HOMEPAGE="http://www.csn.ul.ie/~airlied/pam_smb/"
SRC_URI="
	mirror://samba/pam_smb/v2/${MY_P}.tar.gz
	http://www.csn.ul.ie/~airlied/pam_smb/v2/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND=">=sys-libs/pam-0.75"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}/10-pam_smb-bash-3.1.patch"
}

src_configure() {
	econf --disable-root-only
}

src_install() {
	dopammod pamsmbm/pam_smb_auth.so
	dosbin pamsmbd/pamsmbd

	dodoc BUGS CHANGES README TODO faq/{pam_smb_faq.sgml,additions.txt}
	docinto pam.d
	dodoc pam_smb.conf*

	newinitd "${FILESDIR}/pamsmbd-init pamsmbd"
}

pkg_postinst() {
	echo
	elog "You must create /etc/pam_smb.conf yourself, containing"
	elog "your domainname, PDC and BDC.  See example files in docdir."
	echo
}
