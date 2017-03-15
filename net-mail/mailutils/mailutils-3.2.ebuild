# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils flag-o-matic python-single-r1 toolchain-funcs

DESCRIPTION="A useful collection of mail servers, clients, and filters"
HOMEPAGE="https://www.gnu.org/software/mailutils/mailutils.html"
#SRC_URI="mirror://gnu/mailutils/${P}.tar.xz"
SRC_URI="mirror://gnu/mailutils/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~ppc ~x86 ~ppc-macos ~x64-macos ~x86-macos"
IUSE="berkdb bidi +clients gdbm sasl guile ipv6 kerberos kyotocabinet ldap \
	mysql nls pam postgres python servers ssl static-libs +threads tcpd \
	tokyocabinet"

RDEPEND="!mail-client/nmh
	!mail-filter/libsieve
	!mail-client/mailx
	!mail-client/nail
	sys-libs/ncurses:=
	sys-libs/readline:=
	dev-libs/libltdl:0
	virtual/mta
	berkdb? ( sys-libs/db:= )
	bidi? ( dev-libs/fribidi )
	gdbm? ( sys-libs/gdbm )
	guile? ( dev-scheme/guile:= )
	kerberos? ( virtual/krb5 )
	kyotocabinet? ( dev-db/kyotocabinet )
	ldap? ( net-nds/openldap )
	mysql? ( virtual/mysql )
	nls? ( sys-devel/gettext )
	pam? ( virtual/pam )
	postgres? ( dev-db/postgresql:= )
	python? ( ${PYTHON_DEPS} )
	sasl? ( virtual/gsasl )
	ssl? ( net-libs/gnutls:= )
	tcpd? ( sys-apps/tcp-wrappers )
	tokyocabinet? ( dev-db/tokyocabinet )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )
	servers? ( tcpd )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# Disable bytecompilation of Python modules.
	echo "#!/bin/sh" > build-aux/py-compile
	# bug 567976
	sed -i -e /AM_GNU_GETTEXT_VERSION/s/0.18/0.19/ configure.ac || die
	# add missing tests so that make check doesn't fail
	cp "${FILESDIR}"/{hdr,nohdr,twomsg,weed}.at "${S}"/readmsg/tests || die
	if use mysql; then
		sed -i -e /^INCLUDES/"s:$:$(mysql_config --include):" \
			sql/Makefile.am || die
	fi
	eapply_user
	eautoreconf
}

src_configure() {
	append-flags -fno-strict-aliasing

	# maildir is the Gentoo default
	econf MU_DEFAULT_SCHEME=maildir \
		CURSES_LIBS="$($(tc-getPKG_CONFIG) --libs ncurses)" \
		$(use_with berkdb berkeley-db) \
		$(use_with bidi fribidi) \
		$(use_enable ipv6) \
		$(use_with gdbm) \
		$(use_with sasl gsasl) \
		$(use_with guile) \
		$(use_with kerberos gssapi) \
		$(use_with ldap) \
		$(use_with mysql) \
		$(use_enable nls) \
		$(use_enable pam) \
		$(use_with postgres) \
		$(use_enable python) \
		$(use_with ssl gnutls) \
		$(use_enable static-libs static) \
		$(use_enable threads pthread) \
		$(use_with tokyocabinet) \
		$(use_with kyotocabinet) \
		$(use_with tcpd tcp-wrappers) \
		$(use_enable servers build-servers) \
		$(use_enable clients build-clients) \
		--with-mail-spool=/var/spool/mail \
		--with-readline \
		--enable-sendmail \
		--disable-debug \
		--disable-rpath
}

src_install() {
	emake DESTDIR="${D}" install

	insinto /etc
	doins "${FILESDIR}/mailutils.rc"
	keepdir /etc/mailutils.d/
	insinto /etc/mailutils.d
	doins "${FILESDIR}/mail"

	if use python; then
		python_optimize
		if use static-libs; then
			rm -r "${D}$(python_get_sitedir)/mailutils"/*.{a,la} || die
		fi
	fi

	if use servers; then
		newinitd "${FILESDIR}"/imap4d.initd imap4d
		newinitd "${FILESDIR}"/pop3d.initd pop3d
		newinitd "${FILESDIR}"/comsatd.initd comsatd
	fi

	dodoc AUTHORS ChangeLog NEWS README* THANKS TODO

	# compatibility link
	use clients && dosym /usr/bin/mail /bin/mail

	use static-libs || find "${D}" -name "*.la" -delete
}
