# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools libtool systemd

DESCRIPTION="An IMAP daemon designed specifically for maildirs"
HOMEPAGE="http://www.courier-mta.org/"
SRC_URI="mirror://sourceforge/courier/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 sparc x86"
IUSE="berkdb debug fam +gdbm gnutls ipv6 libressl selinux trashquota"

REQUIRED_USE="|| ( berkdb gdbm )"

CDEPEND="
	gnutls? ( net-libs/gnutls )
	!gnutls? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	>=net-libs/courier-authlib-0.61
	>=net-libs/courier-unicode-1.3
	>=net-mail/mailbase-0.00-r8
	berkdb? ( sys-libs/db:= )
	fam? ( virtual/fam )
	gdbm? ( >=sys-libs/gdbm-1.8.0 )"
DEPEND="${CDEPEND}
	dev-lang/perl
	!mail-mta/courier
	userland_GNU? ( sys-process/procps )"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-courier )"

# get rid of old style virtual - bug 350792
# all blockers really needed?
RDEPEND="${RDEPEND}
	!mail-mta/courier
	!net-mail/bincimap
	!net-mail/cyrus-imapd
	!net-mail/uw-imap"

RC_VER="4.0.6-r1"
INITD_VER="4.0.6-r1"

PATCHES=(
	"${FILESDIR}/${PN}-4.17-disable-fam-configure.ac.patch"
	"${FILESDIR}/${PN}-4.17-aclocal-fix.patch"
)

src_prepare() {
	default

	# These patches should fix problems detecting BerkeleyDB.
	# We now can compile with db4 support.
	if use berkdb ; then
		eapply "${FILESDIR}/${PN}-4.17-db4-bdbobj_configure.ac.patch"
		eapply "${FILESDIR}/${PN}-4.17-db4-configure.ac.patch"
	fi

	eautoreconf
}

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

	use debug && myconf="${myconf} debug=true"

	econf \
		--disable-root-check \
		--bindir=/usr/sbin \
		--sysconfdir="/etc/${PN}" \
		--libexecdir="/usr/$(get_libdir)/${PN}" \
		--localstatedir="/var/lib/${PN}" \
		--with-authdaemonvar="/var/lib/${PN}/authdaemon" \
		--enable-workarounds-for-imap-client-bugs \
		--with-mailuser=mail \
		--with-mailgroup=mail \
		$(use_with fam) \
		$(use_with ipv6) \
		$(use_with gnutls) \
		${myconf}

	# Change the pem file location.
	sed -i -e "s:^\(TLS_CERTFILE=\).*:\1/etc/courier-imap/imapd.pem:" \
		libs/imap/imapd-ssl.dist || \
		die "sed failed"

	sed -i -e "s:^\(TLS_CERTFILE=\).*:\1/etc/courier-imap/pop3d.pem:" \
		libs/imap/pop3d-ssl.dist || \
		die "sed failed"
}

src_compile() {
	# spurious failures with parallel compiles
	emake -j1
}

src_install() {
	dodir "/var/lib/${PN}" /etc/pam.d
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

	dosym /usr/sbin/courierlogger "/usr/$(get_libdir)/${PN}/courierlogger"

	for initd in courier-{imapd,pop3d}{,-ssl} ; do
		sed -e "s:GENTOO_LIBDIR:$(get_libdir):g" \
			"${FILESDIR}/${PN}-${INITD_VER}-${initd}.rc6" \
			> "${T}/${initd}" \
			|| die "initd libdir-sed failed"
		doinitd "${T}/${initd}"
	done

	systemd_newunit "${FILESDIR}"/courier-authdaemond-r1.service \
					courier-authdaemond.service
	systemd_newunit "${FILESDIR}"/courier-imapd-ssl-r1.service \
					courier-imapd-ssl.service
	systemd_newunit "${FILESDIR}"/courier-imapd-r1.service \
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

	dodoc AUTHORS INSTALL NEWS README ChangeLog
	dodoc "${FILESDIR}/${PN}-gentoo.readme"
	docinto imap
	dodoc libs/imap/ChangeLog libs/imap/BUGS* libs/imap/README*
	docinto maildir
	dodoc libs/maildir/AUTHORS libs/maildir/*.html libs/maildir/README*
	docinto rfc2045
	dodoc libs/rfc2045/*.html
	docinto tcpd
	dodoc libs/tcpd/README* libs/tcpd/*.html
}

pkg_postinst() {
	elog "Please read http://www.courier-mta.org/imap/INSTALL.html#upgrading"
	elog "and remove TLS_DHPARAMS from configuration files or run mkdhparams"

	elog "For a quick-start howto please refer to"
	elog "${PN}-gentoo.readme in /usr/share/doc/${PF}"
	# Some users have been reporting that permissions on this directory were
	# getting scrambled, so let's ensure that they are sane.
	fperms 0755 "${ROOT}/usr/$(get_libdir)/${PN}"
}

src_test() {
	ewarn "make check is not supported by this package due to the"
	ewarn "--enable-workarounds-for-imap-client-bugs option."
}
