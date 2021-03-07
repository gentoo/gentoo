# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 lua5-2 )

inherit autotools db-use eutils systemd tmpfiles lua-single

DESCRIPTION="A milter providing DKIM signing and verification"
HOMEPAGE="http://opendkim.org/"
SRC_URI="https://downloads.sourceforge.net/project/opendkim/${P}.tar.gz"

# The GPL-2 is for the init script, bug 425960.
LICENSE="BSD GPL-2 Sendmail-Open-Source"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="berkdb ldap libressl lmdb lua memcached opendbx poll sasl selinux +ssl static-libs stats querycache test unbound"

BDEPEND="acct-user/opendkim
	test? ( ${LUA_DEPS} )"

COMMON_DEPEND="|| ( mail-filter/libmilter mail-mta/sendmail )
	dev-libs/libbsd
	sys-apps/grep
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	berkdb? ( >=sys-libs/db-3.2:* )
	opendbx? ( >=dev-db/opendbx-1.4.0 )
	lua? ( ${LUA_DEPS} )
	ldap? ( net-nds/openldap )
	lmdb? ( dev-db/lmdb )
	memcached? ( dev-libs/libmemcached )
	sasl? ( dev-libs/cyrus-sasl )
	unbound? ( >=net-dns/unbound-1.4.1:= net-dns/dnssec-root )
	!unbound? ( net-libs/ldns )"

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

PATCHES=(
	"${FILESDIR}/${P}-openrc.patch"
	"${FILESDIR}/${P}-openssl-1.1.1.patch.r2"
	"${FILESDIR}/${P}-lua-pkgconfig.patch"
	"${FILESDIR}/${P}-lua-pkgconfig-pt2.patch"
	"${FILESDIR}/${P}-define-P-macro-in-libvbr.patch"
	"${FILESDIR}/${P}-fix-libmilter-search.patch"
)

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_prepare() {
	default
	sed -e 's:/var/db/dkim:/var/lib/opendkim:g' \
		-i opendkim/opendkim.conf.sample opendkim/opendkim.conf.simple.in \
		|| die
	sed -e 's:dist_doc_DATA:dist_html_DATA:' \
		-i libopendkim/docs/Makefile.am \
		|| die

	# The existing hard-coded path under /tmp is vulnerable to exploits
	# since (for example) a user can create a symlink there to a file
	# that portage will clobber. Reported upstream at,
	#
	#   https://github.com/trusteddomainproject/OpenDKIM/issues/113
	#
	sed -e "s:/tmp:${T}:" -i libopendkim/tests/t-testdata.h || die

	eautoreconf
}

src_configure() {
	local myconf=()
	if use berkdb ; then
		myconf+=( --with-db-incdir=$(db_includedir) )
	fi
	if use unbound; then
		myconf+=( --with-unbound )
	else
		myconf+=( --with-ldns )
	fi
	if use ldap; then
		myconf+=( $(use_with sasl) )
	fi

	# We install the our configuration filed under e.g. /etc/opendkim,
	# so the next line is necessary to point the daemon and all of its
	# documentation to the right location by default.
	myconf+=( --sysconfdir="${EPREFIX}/etc/${PN}" )

	econf \
		$(use_with berkdb db) \
		$(use_with opendbx odbx) \
		$(use_with lua) \
		$(use_enable lua rbl) \
		$(use_with ldap openldap) \
		$(use_with lmdb) \
		$(use_enable poll) \
		$(use_enable querycache query_cache) \
		$(use_enable static-libs static) \
		$(use_enable stats) \
		$(use_with memcached libmemcached) \
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

src_compile() {
	emake runstatedir=/run
}

src_test() {
	# Needed for now due to the expected sequencing of the setup/cleanup
	# tests, https://github.com/trusteddomainproject/OpenDKIM/issues/110
	emake -j1 check
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

	# Tweak the "simple" example configuration a bit before installing
	# it unconditionally.
	local cf="${T}/opendkim.conf"
	# Some MTAs are known to break DKIM signatures with "simple"
	# canonicalization [1], so we choose the "relaxed" policy
	# over OpenDKIM's current default settings.
	# [1] https://wordtothewise.com/2016/12/dkim-canonicalization-or-why-microsoft-breaks-your-mail/
	sed -E -e 's:^(Canonicalization)[[:space:]]+.*:\1\trelaxed/relaxed:' \
		"${S}/opendkim/opendkim.conf.simple" >"${cf}" || die
	cat >>"${cf}" <<EOT || die

# The UMask is really only used for the PID file (root:root) and the
# local UNIX socket, if you're using one. It should be 0117 for the
# socket.
UMask			0117
UserID			opendkim

# For use with unbound
#TrustAnchorFile	/etc/dnssec/root-anchors.txt
EOT
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
		keysize=1024
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
	einfo "  http://www.dkim.org/specs/rfc4871-dkimbase.html#key-text"
}
