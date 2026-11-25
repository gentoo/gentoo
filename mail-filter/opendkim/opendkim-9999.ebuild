# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 lua5-2 lua5-3 lua5-4 )

inherit autotools db-use git-r3 systemd tmpfiles lua-single

EGIT_REPO_URI="https://github.com/trusteddomainproject/OpenDKIM"
EGIT_BRANCH="develop"

DESCRIPTION="A milter providing DKIM signing and verification"
HOMEPAGE="http://opendkim.org/"

LICENSE="BSD Sendmail-Open-Source"
SLOT="0"
IUSE="berkdb ldap lmdb lua memcached opendbx sasl selinux stats querycache test unbound"

BDEPEND="acct-user/opendkim
	test? ( ${LUA_DEPS} )"

# strlcpy and strlcat are in both glibc and musl, so we don't need
# dev-libs/libbsd to provide them.
#
# gnutls is supposedly supported as an openssl alternative, but we don't
# need to self-inflict any more problems right now.
COMMON_DEPEND="mail-filter/libmilter:=
	sys-apps/grep
	dev-libs/openssl:0=
	berkdb? ( >=sys-libs/db-3.2:* )
	opendbx? ( >=dev-db/opendbx-1.4.0 )
	lua? ( ${LUA_DEPS} )
	ldap? ( net-nds/openldap:= )
	lmdb? ( dev-db/lmdb:= )
	memcached? (
		|| (
			dev-libs/libmemcached-awesome
			dev-libs/libmemcached
		)
	)
	sasl? ( dev-libs/cyrus-sasl )
	unbound? ( >=net-dns/unbound-1.4.1:= net-dns/dnssec-root )"

DEPEND="${COMMON_DEPEND}"

RDEPEND="${COMMON_DEPEND}
	acct-user/opendkim
	sys-process/psmisc
	selinux? ( sec-policy/selinux-dkim )"

REQUIRED_USE="sasl? ( ldap )
	stats? ( opendbx )
	querycache? ( berkdb )
	lua? ( ${LUA_REQUIRED_USE} )
	test? ( ${LUA_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=()
	if use berkdb ; then
		myconf+=( --with-db-incdir=$(db_includedir) )
	fi
	if use ldap; then
		myconf+=( $(use_with sasl) )
	fi

	# We install the our configuration files under e.g. /etc/opendkim,
	# so the next line is necessary to point the daemon and all of its
	# documentation to the right location by default.
	myconf+=( --sysconfdir="${EPREFIX}/etc/${PN}" )

	# Many of the --with-foo search paths are broken, but upstream would
	# be happy to accept a PR to fix them (try pkg-config first; fall
	# back to a prefix search that begins with the empty prefix):
	#
	#  https://github.com/trusteddomainproject/OpenDKIM/issues/378
	#
	econf \
		$(use_with berkdb db) \
		$(use_with opendbx odbx) \
		$(use_with lua) \
		$(use_enable lua rbl) \
		$(use_with ldap openldap) \
		$(use_with lmdb) \
		$(use_enable querycache query_cache) \
		$(use_enable stats) \
		$(use_with memcached libmemcached) \
		$(use_with unbound) \
		"${myconf[@]}" \
		--enable-filter \
		--with-milter \
		--enable-atps \
		--enable-identity_header \
		--enable-rate_limit \
		--enable-resign \
		--enable-replace_rules \
		--enable-default_sender \
		--enable-sender_macro \
		--enable-vbr \
		--disable-live-testing \
		--with-test-socket="${T}/opendkim.sock"
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die

	dosbin stats/opendkim-reportstats

	newinitd "${S}/contrib/OpenRC/opendkim.openrc" "${PN}"
	newtmpfiles "${S}/contrib/systemd/opendkim.tmpfiles" "${PN}.conf"
	systemd_newunit "contrib/systemd/opendkim.service" "${PN}.service"

	dodir /etc/opendkim
	keepdir /var/lib/opendkim

	# The OpenDKIM data (particularly, your keys) should be read-only to
	# the UserID that the daemon runs as.
	fowners root:opendkim /var/lib/opendkim
	fperms 750 /var/lib/opendkim

	# Install the sample configuration after tweaking it to use
	# a local socket by default.
	local cf="${T}/opendkim.conf"

	sed -e '/^Socket.*inet/d'   \
		-e 's/^#Socket/Socket/' \
		-e 's/^#UserID/UserID/' \
		-e 's/^#UMask/UMask/'   \
		"${S}/opendkim/opendkim.conf.simple" > "${cf}" || die
	insinto /etc/opendkim
	doins "${cf}"
}

pkg_postinst() {
	tmpfiles_process "${PN}.conf"
	if [[ -z ${REPLACING_VERSION} ]]; then
		elog "If you want to sign your mail messages and need some help"
		elog "please run:"
		elog "	emerge --config ${CATEGORY}/${PN}"
		elog "It will help you create your key and give you hints on how"
		elog "to configure your DNS and MTA."

		elog "If you are using a local (UNIX) socket, then you will"
		elog "need to make sure that your MTA has read/write access"
		elog "to the socket file. This is best accomplished by creating"
		elog "a completely-new group with only your MTA user and the"
		elog "\"opendkim\" user in it. Step-by-step instructions can be"
		elog "found on our Wiki, at https://wiki.gentoo.org/wiki/OpenDKIM ."
	else
		ewarn "The user account for the OpenDKIM daemon has changed"
		ewarn "from \"milter\" to \"opendkim\" to prevent unrelated services"
		ewarn "from being able to read your private keys. You should"
		ewarn "adjust your existing configuration to use the \"opendkim\""
		ewarn "user and group, and change the permissions on"
		ewarn "${ROOT}/var/lib/opendkim to root:opendkim with mode 0750."
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
	if [[ -f "${ROOT}/var/lib/opendkim/${selector}.private" ]]; then
		ewarn "The private key for this selector already exists."
	else
		keysize=2048
		# Generate the private and public keys. Note that opendkim-genkeys
		# sets umask=077 on its own to keep these safe. However, we want
		# them to be readable (only!) to the opendkim user, and we manage
		# that by changing their groups and making everything group-readable.
		opendkim-genkey -b ${keysize} -D "${ROOT}/var/lib/opendkim/" \
			-s "${selector}" -d '(your domain)' && \
			chgrp --no-dereference opendkim \
				"${ROOT}/var/lib/opendkim/${selector}".{private,txt} || \
				{ eerror "Failed to create private and public keys."; return 1; }
		chmod g+r "${ROOT}/var/lib/opendkim/${selector}".{private,txt}
	fi

	# opendkim selector configuration
	echo
	einfo "Make sure you have the following settings in your /etc/opendkim/opendkim.conf:"
	einfo "  Keyfile /var/lib/opendkim/${selector}.private"
	einfo "  Selector ${selector}"

	# MTA configuration
	echo
	einfo "If you are using Postfix, add following lines to your main.cf:"
	einfo "  smtpd_milters	   = unix:/run/opendkim/opendkim.sock"
	einfo "  non_smtpd_milters = unix:/run/opendkim/opendkim.sock"
	einfo "  and read http://www.postfix.org/MILTER_README.html"

	# DNS configuration
	einfo "After you configured your MTA, publish your key by adding this TXT record to your domain:"
	cat "${ROOT}/var/lib/opendkim/${selector}.txt"
	einfo "t=y signifies you only test the DKIM on your domain. See following page for the complete list of tags:"
	einfo "  https://www.rfc-editor.org/rfc/rfc6376.html#section-3.6.1"
}
