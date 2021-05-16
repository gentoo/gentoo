# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WEBAPP_MANUAL_SLOT="yes"
inherit autotools qmail webapp

MY_P=${P/_rc/-rc}

DESCRIPTION="A web interface for managing a qmail system with virtual domains"
HOMEPAGE="http://www.inter7.com/qmailadmin.html"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~ia64 ppc ~s390 sparc x86"
IUSE="maildrop"
# the RESTRICT is because the vpopmail lib directory is locked down
# and non-root can't access them.
RESTRICT="userpriv"

RDEPEND="
	net-mail/autorespond
	>=net-mail/vpopmail-5.4.33
	virtual/qmail
	maildrop? ( >=mail-filter/maildrop-2.0.1 )"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	eapply "${FILESDIR}"/${PN}-1.2.9-maildir.patch
	eapply "${FILESDIR}"/${PN}-1.2.12-quota-overflow.patch
	eapply "${FILESDIR}"/${PN}-1.2.15-quota-security.patch
	eapply_user
	eautoreconf
}

src_configure() {
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
		"$@"
}

src_install() {
	webapp_src_preinst

	local DOCS=(
		AUTHORS INSTALL README.hooks BUGS TODO ChangeLog TRANSLATORS
		NEWS FAQ README contrib/*
	)
	default

	webapp_src_install
}

pkg_postinst() {
	einfo "If you would like support for ezmlm mailing lists inside qmailadmin,"
	einfo "please emerge some variant of ezmlm-idx."
	webapp_pkg_postinst
}
