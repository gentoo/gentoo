# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pam toolchain-funcs

MY_P=${P/_rc/-rc}

DESCRIPTION="PAM module for authenticating against an SMB (such as the Win_x families) server"
HOMEPAGE="http://www.csn.ul.ie/~airlied/pam_smb/"
SRC_URI="
	https://download.samba.org/pub/samba/pam_smb/v2/${MY_P}.tar.gz
	http://www.csn.ul.ie/~airlied/pam_smb/v2/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

DEPEND="virtual/libcrypt:=
	>=sys-libs/pam-0.75"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/10-pam_smb-bash-3.1.patch
	"${FILESDIR}"/respect-FLAGS-CC-AR.patch
	"${FILESDIR}"/add-various-missing-includes.patch
)

src_configure() {
	tc-export CC

	LDFLAGS="${LDFLAGS}" econf --disable-root-only
}

src_install() {
	dopammod pamsmbm/pam_smb_auth.so
	dosbin pamsmbd/pamsmbd

	dodoc BUGS CHANGES README TODO faq/{pam_smb_faq.sgml,additions.txt}
	docinto pam.d
	dodoc pam_smb.conf*

	newinitd "${FILESDIR}/pamsmbd-init" pamsmbd
}

pkg_postinst() {
	elog "You must create ${EROOT}/etc/pam_smb.conf yourself, containing"
	elog "your domain name, PDC and BDC.  See example files in docdir."
}
