# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit webapp eutils autotools qmail

DESCRIPTION="A web based control pannel to manage Virtual Qmail Domains. Works with qmailadmin"
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

src_unpack() {
	unpack ${A}
	cd "${S}"

	# fixes for sane webapp integration
	sed -i \
		-e "s|html/|/usr/share/${PN}/|g" \
		-e "s|/images/vqadmin/|/vqadmin/|g" \
		-e "s|/cgi-bin/vqadmin/|/cgi-bin/|g" \
		-e "s|vqadmin\.cgi|vqadmin|g" \
		*.h *.c html/*.html
}

src_compile() {
	econf ${myopts} \
		--enable-qmaildir="${QMAIL_HOME}" \
		--enable-vpopuser=vpopmail \
		--enable-vpopgroup=vpopmail \
		--enable-cgibindir="${MY_CGIBINDIR}" \
	|| die "econf failed"

	emake || die "make failed"
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
