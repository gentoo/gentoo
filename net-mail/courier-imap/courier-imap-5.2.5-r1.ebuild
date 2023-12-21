# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit readme.gentoo-r1 systemd

DESCRIPTION="An IMAP daemon designed specifically for maildirs"
HOMEPAGE="https://www.courier-mta.org/imap/"
SRC_URI="mirror://sourceforge/courier/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

IUSE="berkdb debug +gdbm gnutls ipv6 selinux trashquota"
REQUIRED_USE="|| ( berkdb gdbm )"

CDEPEND="
	gnutls? ( net-libs/gnutls:=[tools] )
	!gnutls? (
		dev-libs/openssl:0=
	)
	net-libs/courier-authlib
	net-libs/courier-unicode
	net-mail/mailbase
	net-dns/libidn:=
	berkdb? ( sys-libs/db:= )
	gdbm? ( sys-libs/gdbm:= )
	!mail-mta/courier
"
DEPEND="${CDEPEND}
	dev-lang/perl
	sys-process/procps
"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-courier )
"

RDEPEND="${RDEPEND}
	!net-mail/cyrus-imapd
	!net-mail/courier-common
	!net-mail/courier-makedat
"

RC_VER="4.0.6-r1"
INITD_VER="4.0.6-r1"

# make check is not supported by this package due to the
# --enable-workarounds-for-imap-client-bugs option.
RESTRICT="test"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
Please read http://www.courier-mta.org/imap/INSTALL.html#upgrading
and remove TLS_DHPARAMS from configuration files or run mkdhparams

For a quick-start howto please refer to
${PN}-gentoo.readme in /usr/share/doc/${PF}

Please convert maildir to utf8
and rerun mkdhparams if needed. Location has changed
"

PATCHES=(
	"${FILESDIR}/${PN}-5.1.8-aclocal-fix.patch"
	"${FILESDIR}/${PN}-5.0.8-ar-fix.patch"
)

src_configure() {
	local myconf=""

	# Default to gdbm if both berkdb and gdbm are present.
	if use gdbm ; then
		einfo "Building with GDBM support"
		myconf="${myconf} --with-db=gdbm"
	elif use berkdb ; then
		einfo "Building with BerkeleyDB support"
		myconf="${myconf} --with-db=db"
	fi

	if use trashquota ; then
		einfo "Building with Trash Quota Support"
		myconf="${myconf} --with-trashquota"
	fi

	econf \
		--with-notice=unicode \
		--disable-root-check \
		--bindir=/usr/sbin \
		--sysconfdir="/etc/${PN}" \
		--libexecdir="/usr/$(get_libdir)/${PN}" \
		--localstatedir="/var/lib/${PN}" \
		--enable-workarounds-for-imap-client-bugs \
		--with-mailuser=mail \
		--with-mailgroup=mail \
		--with-certsdir="/etc/courier-imap" \
		$(use_with ipv6) \
		$(use_with gnutls) \
		${myconf}
}

src_install() {
	dodir "/var/lib/${PN}" /etc/pam.d
	keepdir /var/lib/courier-imap

	default
	rm -r "${D}/etc/pam.d" || die

	# Avoid name collisions in /usr/sbin wrt imapd and pop3d
	for name in imapd pop3d ; do
		mv "${D}/usr/sbin/"{,courier-}${name} \
			|| die "failed to rename ${name} to courier-${name}"
	done

	# Hack /usr/lib/courier-imap/foo.rc to use ${MAILDIR} instead of
	# 'Maildir', and to use /usr/sbin/courier-foo names.
	for service in {imapd,pop3d}{,-ssl} ; do
		sed -e 's/Maildir/${MAILDIR}/' \
			-i "${D}/usr/$(get_libdir)/${PN}/${service}.rc" \
			|| die "sed failed"
		sed -e "s/\/usr\/sbin\/${service}/\/usr\/sbin\/courier-${service}/" \
			-i "${D}/usr/$(get_libdir)/${PN}/${service}.rc" \
			|| die "sed failed"
	done

	# Rename the config files correctly and add a value for ${MAILDIR}
	# to them.
	for service in {imapd,pop3d}{,-ssl} ; do
		mv "${D}/etc/${PN}/${service}"{.dist,} \
			|| die "failed to rename ${service}.dist to ${service}"
		echo -e '\n# Hardwire a value for ${MAILDIR}' \
			 >> "${D}/etc/${PN}/${service}"
		echo 'MAILDIR=.maildir' >> "${D}/etc/${PN}/${service}"
		echo 'MAILDIRPATH=.maildir' >> "${D}/etc/${PN}/${service}"
	done

	for service in imapd pop3d ; do
		echo -e '# Put any program for ${PRERUN} here' \
			 >> "${D}/etc/${PN}/${service}"
		echo 'PRERUN=' >> "${D}/etc/${PN}/${service}"
		echo -e '# Put any program for ${LOGINRUN} here' \
			 >> "${D}/etc/${PN}/${service}"
		echo -e '# this is for relay-ctrl-allow in 4*' \
			 >> "${D}/etc/${PN}/${service}"
		echo 'LOGINRUN=' >> "${D}/etc/${PN}/${service}"
	done

	for x in "${D}/usr/sbin"/* ; do
		if [[ -L "${x}" ]] ; then
			rm "${x}" || die "failed to remove ${x}"
		fi
	done

	mv "${D}/usr/share"/* "${D}/usr/sbin/" || die
	mv "${D}/usr/sbin/man" "${D}/usr/share/" || die

	rm "${D}/usr/sbin/"{mkimapdcert,mkpop3dcert} || die

	dosbin "${FILESDIR}/mkimapdcert" "${FILESDIR}/mkpop3dcert"

	dosym ../../sbin/courierlogger "/usr/$(get_libdir)/${PN}/courierlogger"

	for initd in courier-{imapd,pop3d}{,-ssl} ; do
		sed -e "s:GENTOO_LIBDIR:$(get_libdir):g" \
			"${FILESDIR}/${PN}-${INITD_VER}-${initd}.rc6" \
			> "${T}/${initd}" \
			|| die "initd libdir-sed failed"
		doinitd "${T}/${initd}"
	done

	cp "${FILESDIR}"/courier-*-r1.service .

	sed -i \
		-e "s:/usr/lib/:/usr/$(get_libdir)/:" \
		courier-*-r1.service \
		|| die

	systemd_newunit courier-authdaemond-r1.service \
					courier-authdaemond.service
	systemd_newunit courier-imapd-ssl-r1.service \
					courier-imapd-ssl.service
	systemd_newunit courier-imapd-r1.service \
					courier-imapd.service

	exeinto "/usr/$(get_libdir)/${PN}"
	for exe in gentoo-{imapd,pop3d}{,-ssl}.rc courier-{imapd,pop3d}.indirect ; do
		sed -e "s:GENTOO_LIBDIR:$(get_libdir):g" \
			"${FILESDIR}/${PN}-${RC_VER}-${exe}" \
			> "${T}/${exe}" \
			|| die "exe libdir-sed failed"
		doexe "${T}/${exe}"
	done

	# Avoid a collision with mail-mta/netqmail, bug 482098.
	mv "${D}/usr/sbin/"{,courier-}maildirmake \
		|| die "failed to rename maildirmake to courier-maildirmake"
	mv "${D}/usr/share/man/man1/"{,courier-}maildirmake.1 \
		|| die "failed to rename maildirmake.1 to courier-maildirmake.1"

	rm -rf "${D}"/usr/sbin/doc

	dodoc AUTHORS INSTALL NEWS README ChangeLog
	readme.gentoo_create_doc
	dodoc "${FILESDIR}/${PN}-gentoo.readme"
	docinto imap
	dodoc libs/imap/ChangeLog libs/imap/BUGS* libs/imap/README*
	docinto maildir
	dodoc libs/maildir/AUTHORS libs/maildir/*.html libs/maildir/README*
	docinto rfc2045
	dodoc libs/rfc2045/*.html
	docinto tcpd
	dodoc libs/tcpd/README* libs/tcpd/*.html
	exeinto /etc/cron.monthly
	newexe "${FILESDIR}"/${PN}.cron ${PN}
}

pkg_postinst() {
	# Some users have been reporting that permissions on this directory were
	# getting scrambled, so let's ensure that they are sane.
	fperms 0755 "${ROOT}/usr/$(get_libdir)/${PN}"

	readme.gentoo_print_elog

	elog ""
	elog "Courier Imap now run as user mail:mail."
	elog ""
	elog "This require you to enable read/write access to the caches:"
	elog "/var/lib/courier-imap/courierssl*cache (chown mail:mail)"
	elog "and read access to the certificates (e.g. /etc/courier-imap/pop3d.pem )"
}
