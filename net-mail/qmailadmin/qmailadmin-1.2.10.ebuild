# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/qmailadmin/qmailadmin-1.2.10.ebuild,v 1.11 2012/06/18 23:25:29 jer Exp $

inherit eutils

# TODO: convert this ebuild to use web-app.

# the RESTRICT is because the vpopmail lib directory is locked down
# and non-root can't access them.
RESTRICT='userpriv'

MY_PV="${PV/_rc/-rc}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="A web interface for managing a qmail system with virtual domains"
HOMEPAGE="http://www.inter7.com/qmailadmin.html"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ppc s390 sh sparc x86"
IUSE="maildrop"

DEPEND="virtual/qmail
	>=net-mail/vpopmail-5.3
	net-mail/autorespond
	maildrop? ( >=mail-filter/maildrop-2.0.1 )"
RDEPEND="${DEPEND}"
# apache and lighttpd both work, but there's no virtual yet
#	www-servers/apache"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-1.2.9-maildir.patch
}

src_compile() {
	local dir_vpopmail="/var/vpopmail"
	local dir_vhost="/var/www/localhost"
	local dir_htdocs="${dir_vhost}/htdocs/${PN}"
	local dir_htdocs_images="${dir_htdocs}/images"
	local url_htdocs_images="/${PN}/images"
	local dir_cgibin="${dir_vhost}/cgi-bin"
	local url_cgibin="/cgi-bin/${PN}"
	local dir_htdocs_htmlib="/usr/share/${PN}/htmllib"
	local dir_qmail="/var/qmail"
	local dir_true="/bin"
	local dir_ezmlm="/usr/bin"
	local dir_autorespond="/var/qmail/bin"

	# Pass spam stuff through $@ so we get the quoting right
	if use maildrop ; then
		set -- --enable-modify-spam \
			--enable-spam-command='|preline maildrop /etc/maildroprc'
	else
		set --
	fi

	econf \
		--enable-valias \
		--enable-vpopmaildir=${dir_vpopmail} \
		--enable-htmldir=${dir_htdocs} \
		--enable-imageurl=${url_htdocs_images} \
		--enable-imagedir=${dir_htdocs_images} \
		--enable-htmllibdir=${dir_htdocs_htmlib} \
		--enable-qmaildir=${dir_qmail} \
		--enable-true-path=${dir_true} \
		--enable-ezmlmdir=${dir_ezmlm} \
		--enable-cgibindir=${dir_cgibin} \
		--enable-cgipath=${url_cgibin} \
		--enable-autoresponder-path=${dir_autorespond} \
		--enable-domain-autofill \
		--enable-modify-quota \
		--enable-no-cache \
		--enable-maxusersperpage=50 \
		--enable-maxaliasesperpage=50 \
		--enable-vpopuser=vpopmail \
		--enable-vpopgroup=vpopmail \
		"$@" \
		|| die "econf failed"
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS INSTALL README.hooks BUGS TODO ChangeLog TRANSLATORS NEWS FAQ README contrib/*
}

pkg_postinst() {
	elog "If you would like support for ezmlm mailing lists inside qmailadmin,"
	elog "please emerge some variant of ezmlm-idx."
}
