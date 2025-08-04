# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
PYTHON_COMPAT=( python3_{12..14} )

inherit autotools elisp-common flag-o-matic guile-single python-single-r1 toolchain-funcs

DESCRIPTION="A useful collection of mail servers, clients, and filters"
HOMEPAGE="https://mailutils.org/"
SRC_URI="mirror://gnu/mailutils/${P}.tar.xz"

LICENSE="GPL-3+ LGPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~ppc-macos ~x64-macos"
IUSE="berkdb bidi +clients emacs gdbm sasl guile kerberos kyotocabinet \
	ldap mysql nls pam postgres python servers split-usr ssl static-libs test +threads tcpd \
	tokyocabinet"
RESTRICT="!test? ( test )"

RDEPEND="
	!mail-filter/libsieve
	!mail-client/mailx
	sys-libs/ncurses:=
	sys-libs/readline:=
	dev-libs/libltdl:0
	virtual/libcrypt:=
	virtual/mta
	berkdb? ( sys-libs/db:= )
	bidi? ( dev-libs/fribidi )
	emacs? ( >=app-editors/emacs-23.1:* )
	gdbm? ( sys-libs/gdbm:= )
	guile? ( ${GUILE_DEPS} )
	kerberos? ( virtual/krb5 )
	kyotocabinet? ( dev-db/kyotocabinet )
	ldap? ( net-nds/openldap:= )
	mysql? ( dev-db/mysql-connector-c:= )
	nls? ( sys-devel/gettext )
	pam? ( sys-libs/pam:= )
	postgres? ( dev-db/postgresql:= )
	python? ( ${PYTHON_DEPS} )
	sasl? ( >=net-misc/gsasl-2.0.0 )
	servers? ( virtual/libiconv dev-libs/libunistring:= )
	ssl? ( net-libs/gnutls:= )
	tcpd? ( sys-apps/tcp-wrappers )
	tokyocabinet? ( dev-db/tokyocabinet )
	"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	test? ( dev-util/dejagnu )
"

REQUIRED_USE="
	guile? ( ${GUILE_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )
	servers? ( tcpd ldap )"

DOCS=( ABOUT-NLS AUTHORS COPYING COPYING.LESSER ChangeLog INSTALL NEWS README THANKS TODO )
PATCHES=(
	"${FILESDIR}"/${PN}-3.5-add-include.patch
)

pkg_setup() {
	use guile && guile-single_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	if use guile; then
		guile_bump_sources
		sed -i -e "s|guile|${GUILE}|" libmu_scm/tests/testsuite || die
	fi
	if use mysql; then
		sed -i -e /^INCLUDES/"s:$:$(mysql_config --include):" \
			sql/Makefile.am || die
	fi
	eautoreconf
}

src_configure() {
	# bug #943873
	append-cflags -std=gnu17

	if use guile; then
		export GUILE_SNARF="${GUILESNARF}"
		export GUILE_TOOLS="${GUILE/guile/guile-tools}"
	fi

	# maildir is the Gentoo default
	econf \
		MU_DEFAULT_SCHEME=maildir \
		CURSES_LIBS="$($(tc-getPKG_CONFIG) --libs ncurses)" \
		$(use_with berkdb berkeley-db) \
		$(use_with bidi fribidi) \
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
		$(use_with servers unistring ) \
		$(use_enable clients build-clients) \
		EMACS=$(usex emacs emacs no) \
		--with-lispdir="${EPREFIX}${SITELISP}/${PN}" \
		--with-mail-spool=/var/spool/mail \
		--with-readline \
		--enable-ipv6 \
		--enable-sendmail \
		--disable-debug
}

src_install() {
	default

	insinto /etc
	# bug 613112
	newins "${FILESDIR}/mailutils.rc" mailutils.conf
	keepdir /etc/mailutils.d/
	insinto /etc/mailutils.d
	doins "${FILESDIR}/mail"

	use guile && guile_unstrip_ccache

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

	# compatibility link
	if use clients && use split-usr; then
		dosym ../usr/bin/mail /bin/mail
	fi

	if ! use static-libs; then
		find "${D}" -name "*.la" -delete || die
	fi
}
