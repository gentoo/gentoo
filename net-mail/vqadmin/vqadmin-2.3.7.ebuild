# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit webapp autotools qmail

DESCRIPTION="A web based control pannel to manage Virtual Qmail Domains"
HOMEPAGE="http://www.inter7.com/index.php?page=vqadmin"
SRC_URI="http://www.inter7.com/vqadmin/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
WEBAPP_MANUAL_SLOT="yes"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="virtual/qmail
	>=net-mail/vpopmail-5.3"
RDEPEND="${DEPEND}
	net-mail/qmailadmin"

src_prepare() {
	default

	# fixes for sane webapp integration
	sed -i \
		-e "s|html/|/usr/share/${PN}/|g" \
		-e "s|/images/vqadmin/|/vqadmin/|g" \
		-e "s|/cgi-bin/vqadmin/|/cgi-bin/|g" \
		-e "s|vqadmin\.cgi|vqadmin|g" \
		*.h *.c html/*.html || die
}

src_configure() {
	econf \
		--enable-qmaildir="${QMAIL_HOME}" \
		--enable-vpopuser=vpopmail \
		--enable-vpopgroup=vpopmail \
		--enable-cgibindir="${MY_CGIBINDIR}"
}

src_install () {
	webapp_src_preinst

	insinto /usr/share/${PN}
	doins html/*

	insinto "${MY_HTDOCSDIR}"
	doins html/*.css

	insinto "${MY_CGIBINDIR}"
	doins vqadmin.acl
	insopts -m 755
	doins vqadmin

	dodoc ACL AUTHORS BUGS ChangeLog FAQ INSTALL NEWS TODO README

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
