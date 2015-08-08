# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit qmail eutils webapp autotools

# the RESTRICT is because the vpopmail lib directory is locked down
# and non-root can't access them.
RESTRICT="userpriv"

MY_P=${P/_rc/-rc}

DESCRIPTION="A web interface for managing a qmail system with virtual domains"
HOMEPAGE="http://www.inter7.com/qmailadmin.html"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
WEBAPP_MANUAL_SLOT="yes"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~s390 ~sh ~sparc ~x86"
IUSE="maildrop"

DEPEND="virtual/qmail
	>=net-mail/vpopmail-5.4.33
	net-mail/autorespond
	maildrop? ( >=mail-filter/maildrop-2.0.1 )"

S="${WORKDIR}"/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-1.2.9-maildir.patch
	eautoreconf
}

src_compile() {
	# Pass spam stuff through $@ so we get the quoting right
	if use maildrop ; then
		set -- --enable-modify-spam \
			--enable-spam-command='|preline maildrop /etc/maildroprc'
	else
		set --
	fi

	econf \
		--enable-valias \
		--enable-vpopmaildir=/var/vpopmail \
		--enable-htmldir="${MY_HTDOCSDIR}" \
		--enable-imagedir="${MY_HTDOCSDIR}"/images \
		--enable-imageurl=/${PN}/images \
		--enable-htmllibdir=/usr/share/${PN}/htmllib \
		--enable-cgibindir="${MY_CGIBINDIR}" \
		--enable-cgipath=/cgi-bin/${PN} \
		--enable-qmaildir="${QMAIL_HOME}" \
		--enable-autoresponder-path="${QMAIL_HOME}"/bin \
		--enable-true-path=/bin \
		--enable-ezmlmdir=/usr/bin \
		--enable-domain-autofill \
		--enable-modify-quota \
		--enable-no-cache \
		--enable-trivial-password \
		--enable-catchall \
		--enable-maxusersperpage=50 \
		--enable-maxaliasesperpage=50 \
		--enable-vpopuser=vpopmail \
		--enable-vpopgroup=vpopmail \
		"$@" \
		|| die "econf failed"

	emake || die "make failed"
}

src_install() {
	webapp_src_preinst

	make DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS INSTALL README.hooks BUGS TODO ChangeLog \
		TRANSLATORS NEWS FAQ README contrib/*

	webapp_src_install

	# CGI needs to be able to read /etc/vpopmail.conf
	# Which is 0640 root:vpopmail, as it contains passwords
	cgi=/usr/share/webapps/${PN}/${PV}/hostroot/cgi-bin/qmailadmin
	fowners root:vpopmail $cgi
	fperms g+s $cgi
}

pkg_postinst() {
	einfo "If you would like support for ezmlm mailing lists inside qmailadmin,"
	einfo "please emerge some variant of ezmlm-idx."
	webapp_pkg_postinst
	einfo "For complete webapp-config support:"
	einfo "1. Add this for the Apache cgi-bin dir: Options +ExecCGI -MultiViews +FollowSymLinks"
	einfo "2. Run: webapp-config -I -h localhost -d qmailadmin $PN $PV"
	einfo "3. Symlink: ln -s {/usr/share/webapps/${PN}/${PV}/hostroot,/var/www/localhost}/cgi-bin/${PN}"
}
