# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools db-use flag-o-matic pam systemd eapi7-ver

DESCRIPTION="Open Source Jabber Server"
HOMEPAGE="http://jabberd2.org"
SRC_URI="https://github.com/jabberd2/jabberd2/releases/download/jabberd-${PV}/jabberd-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="berkdb debug experimental ldap libressl memdebug mysql pam postgres sqlite ssl test websocket zlib"
REQUIRED_USE="memdebug? ( debug )"

DEPEND="
	dev-libs/expat
	net-libs/udns
	net-dns/libidn
	virtual/gsasl
	berkdb? ( >=sys-libs/db-4.1.25:= )
	ldap? ( net-nds/openldap )
	mysql? (
		virtual/libmysqlclient:=
		virtual/mysql:=
	)
	pam? ( virtual/pam )
	postgres? ( dev-db/postgresql:= )
	ssl? (
		!libressl? ( >=dev-libs/openssl-1.0.1:0[-bindist] )
		libressl? ( dev-libs/libressl:= )
	)
	sqlite? ( dev-db/sqlite:3 )
	websocket? ( net-libs/http-parser:= )
	zlib? ( sys-libs/zlib )
"
RDEPEND="
	${DEPEND}
	>=net-im/jabber-base-0.01
"
DEPEND="
	${DEPEND}
	app-arch/xz-utils
	sys-devel/autoconf-archive
	virtual/pkgconfig
	test? ( dev-libs/check )
"

DOCS=( AUTHORS README )

PATCHES=(
	"${FILESDIR}/jabberd2-2.6.1-openssl-1.1.patch"
)

S="${WORKDIR}/jabberd-${PV}"

pkg_pretend() {
	if is-flagq '-O[3s]' ; then
		ewarn "O3/Os compiler flags have been known to cause problems"
		ewarn "with old gcc version. Be aware that this could break"
		ewarn "port binding. Make sure to test this."
		ewarn "See https://github.com/jabberd2/jabberd2/issues/34"
	fi
}

src_prepare() {
	# Fix some default directory locations
	sed -i \
		-e 's,@localstatedir@/@package@/pid/,/var/run/,g' \
		-e 's,@localstatedir@/@package@/run/pbx,/var/run/@package@/pbx,g' \
		-e 's,@localstatedir@/@package@/log/,/var/log/@package@/,g' \
		-e 's,@localstatedir@/lib/jabberd2/fs,@localstatedir@/@package@/fs,g' \
		-e 's,@localstatedir@,/var/spool,g' \
		-e 's,@package@,jabber,g' \
		etc/{sm,router,c2s,s2s}.xml.dist.in || die "fixing default directory locations failed!"

	# Disable pidfile generation
	sed -i \
		-e 's,<pidfile>.*</pidfile>,<!-- & -->,g' \
		etc/{sm,router,c2s,s2s}.xml.dist.in || die "comment out <pidfile> failed!"

	# If the package wasn't merged with sqlite then default to use berkdb
	use sqlite ||
		sed -i \
			-e 's,<\(module\|driver\)>sqlite<\/\1>,<\1>db</\1>,g' \
			etc/{c2s,sm}.xml.dist.in || die "setting berkdb as default failed!"

	# avoid file collision with x11-misc/screen-message wrt #453994
	sed -i \
		-e 's/@jabberd_router_bin@/jabberd2-router/' \
		-e 's/@jabberd_c2s_bin@/jabberd2-c2s/' \
		-e 's/@jabberd_s2s_bin@/jabberd2-s2s/' \
		-e 's/@jabberd_sm_bin@/jabberd2-sm/' \
		etc/jabberd*.in || die "fixing file collisions failed!"

	for i in router sm c2s s2s; do
		# rename pid files wrt #241472
		sed -i \
			-e "/pidfile/s/\${id}\.pid/jabberd2-${i}\.pid/" \
			etc/${i}.xml.dist.in || die
	done

	# rename man page names to match binaries
	sed -i -e 's/@,$$bin,g/@,jabberd2-$$bin,g/' man/Makefile.am || die

	default

	eautoreconf
}

src_configure() {
	# --enable-pool-debug is currently broken
	myeconfargs=(
		--sysconfdir=/etc/jabber
		--enable-pipe
		--enable-anon
		--enable-fs
		$(usex debug "--enable-debug" "")
		$(usex memdebug "--enable-nad-debug" "")
		$(use_enable ssl)
		$(use_enable mysql)
		$(use_enable postgres pgsql)
		$(use_enable sqlite)
		$(use_enable berkdb db)
		$(use_enable ldap)
		$(use_enable pam)
		$(use_enable websocket)
		$(use_enable experimental)
		$(use_enable test tests)
		$(usex berkdb "--with-extra-include-path=$(db_includedir)" "")
		$(use_with zlib)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	local i

	# Fix systemd unit files installation path, bug #626026
	emake systemddir="$(systemd_get_systemunitdir)" DESTDIR="${D}" install
	einstalldocs
	find "${D}" -name '*.la' -delete || die

	keepdir /var/spool/jabber/{fs,db}
	fowners jabber:jabber /var/spool/jabber/{fs,db}
	fperms 770 /var/spool/jabber/{fs,db}

	for i in router sm c2s s2s; do
		newinitd "${FILESDIR}/${PN}-2.6.1.init" jabberd2-${i}
		# avoid file collision with x11-misc/screen-message wrt #453994
		einfo "renaming /usr/bin/${i} to /usr/bin/jabberd2-${i}"
		mv "${ED%/}"/usr/bin/${i} "${ED%/}"/usr/bin/jabberd2-${i} || die
		mv "${ED%/}"/usr/share/man/man8/${i}.8 "${ED%/}"/usr/share/man/man8/jabberd2-${i}.8 || die
	done

	newpamd "${FILESDIR}/${PN}-2.3.1.pamd" jabberd
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}-2.6.1.logrotate" jabberd2

	docompress -x /usr/share/doc/${PF}/tools
	docinto tools
	dodoc tools/db-setup{.mysql,.pgsql,.sqlite} \
		tools/{migrate-jd14dir-2-sqlite.pl,pipe-auth.pl}

	# remove useless upstart files wrt #498900
	rm -rf "${ED%/}"/usr/etc || die
}

pkg_postinst() {
	if use pam; then
		echo
		ewarn 'Jabberd-2 PAM authentication requires your unix usernames to'
		ewarn 'be in the form of "contactname@jabberdomain". This behavior'
		ewarn 'is likely to change in future versions of jabberd-2. It may'
		ewarn 'be advisable to avoid PAM authentication for the time being.'
		echo
	fi

	if use sqlite || use mysql || use postgres; then
		echo
		einfo "You will need to setup or update your database using the"
		einfo "scripts in /usr/share/doc/${PF}/tools/"
		echo
	fi

	for v in ${REPLACING_VERSIONS}; do
		if ver_test ${v} -lt 2.6.1-r1; then
			ewarn 'Starting with version 2.6.1-r1 the init script has been split up'
			ewarn 'into separate scripts for each component. Please remove the old jabberd'
			ewarn 'init script from all runlevels and add the relevant new init scripts'
			ewarn 'to the default runlevel.'
			break;
		fi
	done
}
