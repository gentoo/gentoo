# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools db-use eutils systemd user

DESCRIPTION="A milter providing DKIM signing and verification"
HOMEPAGE="http://opendkim.org/"
SRC_URI="mirror://sourceforge/opendkim/${P}.tar.gz"

# The GPL-2 is for the init script, bug 425960.
LICENSE="BSD GPL-2 Sendmail-Open-Source"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="+berkdb gnutls ldap libressl lmdb lua memcached opendbx poll sasl selinux +ssl static-libs unbound"

DEPEND="|| ( mail-filter/libmilter mail-mta/sendmail )
	dev-libs/libbsd
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	berkdb? ( >=sys-libs/db-3.2:* )
	opendbx? ( >=dev-db/opendbx-1.4.0 )
	lua? ( dev-lang/lua:* )
	ldap? ( net-nds/openldap )
	lmdb? ( dev-db/lmdb )
	memcached? ( dev-libs/libmemcached )
	sasl? ( dev-libs/cyrus-sasl )
	unbound? ( >=net-dns/unbound-1.4.1:= net-dns/dnssec-root )
	!unbound? ( net-libs/ldns )
	gnutls? ( >=net-libs/gnutls-3.3 )"

RDEPEND="${DEPEND}
	sys-process/psmisc
	selinux? ( sec-policy/selinux-dkim )
"

REQUIRED_USE="sasl? ( ldap )"

PATCHES=(
	"${FILESDIR}/${P}-gnutls-3.4.patch"
	"${FILESDIR}/${P}-openssl-1.1.1.patch"
)

pkg_setup() {
	# This user can read your private keys, and must therefore not be
	# shared with any other package.
	enewuser opendkim
}

src_prepare() {
	default

	# We delete the "Socket" setting because it's overridden by our
	# conf.d file.
	sed -e 's:/var/db/dkim:/var/lib/opendkim:g' \
		-e '/^[[:space:]]*Socket/d' \
		-i opendkim/opendkim.conf.sample opendkim/opendkim.conf.simple.in \
		stats/opendkim-reportstats{,.in} || die

	sed -i -e 's:dist_doc_DATA:dist_html_DATA:' libopendkim/docs/Makefile.am \
		|| die

	# TODO: what purpose does this serve, do the tests even get run?
	sed -e "/sock.*mt.getcwd/s:mt.getcwd():${T}:" \
		-i opendkim/tests/*.lua || die

	eautoreconf
}

src_configure() {
	local myconf=()
	if use berkdb ; then
		myconf+=(
			$(db_includedir)
			--with-db-incdir=${myconf#-I}
			--enable-popauth
			--enable-query_cache
			--enable-stats
		)
	fi
	if use unbound; then
		myconf+=( --with-unbound )
	else
		myconf+=( --with-ldns )
	fi
	if use ldap; then
		myconf+=( $(use_with sasl) )
	fi
	econf \
		$(use_with berkdb db) \
		$(use_with opendbx odbx) \
		$(use_with lua) \
		$(use_enable lua rbl) \
		$(use_with ldap openldap) \
		$(use_with lmdb) \
		$(use_enable poll) \
		$(use_enable static-libs static) \
		$(use_with gnutls) \
		$(use_with memcached libmemcached) \
		"${myconf[@]}" \
		--enable-filter \
		--enable-atps \
		--enable-identity_header \
		--enable-rate_limit \
		--enable-resign \
		--enable-replace_rules \
		--enable-default_sender \
		--enable-sender_macro \
		--enable-vbr \
		--disable-live-testing
}

src_install() {
	default
	prune_libtool_files

	dosbin stats/opendkim-reportstats

	newinitd "${FILESDIR}/opendkim.init.r5" opendkim
	newconfd "${FILESDIR}/opendkim.confd" opendkim
	systemd_newunit "${FILESDIR}/opendkim-r3.service" opendkim.service
	systemd_install_serviced "${FILESDIR}/${PN}.service.conf" "${PN}.service"

	dodir /etc/opendkim
	keepdir /var/lib/opendkim

	# The OpenDKIM data (particularly, your keys) should be read-only to
	# the UserID that the daemon runs as.
	fowners root:opendkim /var/lib/opendkim
	fperms 750 /var/lib/opendkim

	# Strip the comments out of the "simple" example configuration...
	grep ^[^#] "${S}"/opendkim/opendkim.conf.simple \
		 > "${T}/opendkim.conf" || die

	# and tweak it a bit before installing it unconditionally.
	echo "# For use with unbound" >> "${T}/opendkim.conf" || die
	echo "#TrustAnchorFile /etc/dnssec/root-anchors.txt" \
		 >> "${T}/opendkim.conf" || die
	echo UserID opendkim >> "${T}/opendkim.conf" || die
	insinto /etc/opendkim
	doins "${T}/opendkim.conf"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSION} ]]; then
		elog "If you want to sign your mail messages and need some help"
		elog "please run:"
		elog "  emerge --config ${CATEGORY}/${PN}"
		elog "It will help you create your key and give you hints on how"
		elog "to configure your DNS and MTA."

		# TODO: This is tricky, we really need a good wiki page showing
		# how to share a local socket with an MTA!
		elog "If you are using a local (UNIX) socket, then you will"
		elog "need to make sure that your MTA has read/write access"
		elog "to the socket file. This is best accomplished by creating"
		elog "a completely-new group with only your MTA user and the "
		elog "\"opendkim\" user in it. You would then set \"UMask 0112\""
		elog "in your opendkim.conf, and switch the primary group of your"
		elog "\"opendkim\" user to the group that you just created. The"
		elog "last step is necessary for the socket to be created as the"
		elog "new group (and not as group \"opendkim\")".
	else
		ewarn "The user account for the OpenDKIM daemon has changed"
		ewarn "from \"milter\" to \"opendkim\" to prevent unrelated services"
		ewarn "from being able to read your private keys. You should"
		ewarn "adjust your existing configuration to use the \"opendkim\""
		ewarn "user and group, and change the permissions on"
		ewarn "${ROOT}var/lib/opendkim to root:opendkim with mode 0750."
		ewarn "The owner and group of the files within that directory"
		ewarn "will likely need to be adjusted as well."
	fi
}

pkg_config() {
	local selector keysize pubkey

	read -p "Enter the selector name (default ${HOSTNAME}): " selector
	[[ -n "${selector}" ]] || selector="${HOSTNAME}"
	if [[ -z "${selector}" ]]; then
		eerror "Oddly enough, you don't have a HOSTNAME."
		return 1
	fi
	if [[ -f "${ROOT}var/lib/opendkim/${selector}.private" ]]; then
		ewarn "The private key for this selector already exists."
	else
		keysize=1024
		# Generate the private and public keys. Note that opendkim-genkeys
		# sets umask=077 on its own to keep these safe. However, we want
		# them to be readable (only!) to the opendkim user, and we manage
		# that by changing their groups and making everything group-readable.
		opendkim-genkey -b ${keysize} -D "${ROOT}"var/lib/opendkim/ \
			-s "${selector}" -d '(your domain)' && \
			chgrp --no-dereference opendkim \
				  "${ROOT}var/lib/opendkim/${selector}".{private,txt} || \
				{ eerror "Failed to create private and public keys." ;
				  return 1; }
		chmod g+r "${ROOT}var/lib/opendkim/${selector}".{private,txt}
	fi

	# opendkim selector configuration
	echo
	einfo "Make sure you have the following settings in your /etc/opendkim/opendkim.conf:"
	einfo "  Keyfile /var/lib/opendkim/${selector}.private"
	einfo "  Selector ${selector}"

	# MTA configuration
	echo
	einfo "If you are using Postfix, add following lines to your main.cf:"
	einfo "  smtpd_milters     = unix:/run/opendkim/opendkim.sock"
	einfo "  non_smtpd_milters = unix:/run/opendkim/opendkim.sock"
	einfo "  and read http://www.postfix.org/MILTER_README.html"

	# DNS configuration
	einfo "After you configured your MTA, publish your key by adding this TXT record to your domain:"
	cat "${ROOT}var/lib/opendkim/${selector}.txt"
	einfo "t=y signifies you only test the DKIM on your domain. See following page for the complete list of tags:"
	einfo "  http://www.dkim.org/specs/rfc4871-dkimbase.html#key-text"
}
