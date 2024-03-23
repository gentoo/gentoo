# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/openssh.org.asc
inherit user-info flag-o-matic autotools optfeature pam systemd toolchain-funcs verify-sig

# Make it more portable between straight releases
# and _p? releases.
PARCH=${P/_}

DESCRIPTION="Port of OpenBSD's free SSH release"
HOMEPAGE="https://www.openssh.com/"
SRC_URI="
	mirror://openbsd/OpenSSH/portable/${PARCH}.tar.gz
	verify-sig? ( mirror://openbsd/OpenSSH/portable/${PARCH}.tar.gz.asc )
"
S="${WORKDIR}/${PARCH}"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
# Probably want to drop ssl defaulting to on in a future version.
IUSE="abi_mips_n32 audit debug kerberos ldns libedit livecd pam +pie security-key selinux +ssl static test xmss"

RESTRICT="!test? ( test )"

REQUIRED_USE="
	ldns? ( ssl )
	pie? ( !static )
	static? ( !kerberos !pam )
	xmss? ( ssl  )
	test? ( ssl )
"

# tests currently fail with XMSS
REQUIRED_USE+="test? ( !xmss )"

LIB_DEPEND="
	audit? ( sys-process/audit[static-libs(+)] )
	ldns? (
		net-libs/ldns[static-libs(+)]
		net-libs/ldns[ecdsa(+),ssl(+)]
	)
	libedit? ( dev-libs/libedit:=[static-libs(+)] )
	security-key? ( >=dev-libs/libfido2-1.5.0:=[static-libs(+)] )
	selinux? ( >=sys-libs/libselinux-1.28[static-libs(+)] )
	ssl? ( >=dev-libs/openssl-1.1.1l-r1:0=[static-libs(+)] )
	virtual/libcrypt:=[static-libs(+)]
	>=sys-libs/zlib-1.2.3:=[static-libs(+)]
"
RDEPEND="
	acct-group/sshd
	acct-user/sshd
	!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	pam? ( sys-libs/pam )
	kerberos? ( virtual/krb5 )
"
DEPEND="
	${RDEPEND}
	virtual/os-headers
	kernel_linux? ( !prefix-guest? ( >=sys-kernel/linux-headers-5.1 ) )
	static? ( ${LIB_DEPEND} )
"
RDEPEND="
	${RDEPEND}
	!net-misc/openssh-contrib
	pam? ( >=sys-auth/pambase-20081028 )
	!prefix? ( sys-apps/shadow )
"
BDEPEND="
	dev-build/autoconf
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-openssh )
"

PATCHES=(
	"${FILESDIR}/${PN}-9.3_p1-deny-shmget-shmat-shmdt-in-preauth-privsep-child.patch"
	"${FILESDIR}/${PN}-9.4_p1-Allow-MAP_NORESERVE-in-sandbox-seccomp-filter-maps.patch"
)

pkg_pretend() {
	local i enabled_eol_flags disabled_eol_flags
	for i in hpn sctp X509; do
		if has_version "net-misc/openssh[${i}]"; then
			enabled_eol_flags+="${i},"
			disabled_eol_flags+="-${i},"
		fi
	done

	if [[ -n ${enabled_eol_flags} && ${OPENSSH_EOL_USE_FLAGS_I_KNOW_WHAT_I_AM_DOING} != yes ]]; then
		# Skip for binary packages entirely because of environment saving, bug #907892
		[[ ${MERGE_TYPE} == binary ]] && return

		ewarn "net-misc/openssh does not support USE='${enabled_eol_flags%,}' anymore."
		ewarn "The Base system team *STRONGLY* recommends you not rely on this functionality,"
		ewarn "since these USE flags required third-party patches that often trigger bugs"
		ewarn "and are of questionable provenance."
		ewarn
		ewarn "If you must continue relying on this functionality, switch to"
		ewarn "net-misc/openssh-contrib. You will have to remove net-misc/openssh from your"
		ewarn "world file first: 'emerge --deselect net-misc/openssh'"
		ewarn
		ewarn "In order to prevent loss of SSH remote login access, we will abort the build."
		ewarn "Whether you proceed with disabling the USE flags or switch to the -contrib"
		ewarn "variant, when re-emerging you will have to set"
		ewarn
		ewarn "  OPENSSH_EOL_USE_FLAGS_I_KNOW_WHAT_I_AM_DOING=yes"

		die "Building net-misc/openssh[${disabled_eol_flags%,}] without OPENSSH_EOL_USE_FLAGS_I_KNOW_WHAT_I_AM_DOING=yes"
	fi

	# Make sure people who are using tcp wrappers are notified of its removal. #531156
	if grep -qs '^ *sshd *:' "${EROOT}"/etc/hosts.{allow,deny} ; then
		ewarn "Sorry, but openssh no longer supports tcp-wrappers, and it seems like"
		ewarn "you're trying to use it.  Update your ${EROOT}/etc/hosts.{allow,deny} please."
	fi
}

src_prepare() {
	# don't break .ssh/authorized_keys2 for fun
	sed -i '/^AuthorizedKeysFile/s:^:#:' sshd_config || die

	[[ -d ${WORKDIR}/patches ]] && PATCHES+=( "${WORKDIR}"/patches )

	default

	# These tests are currently incompatible with PORTAGE_TMPDIR/sandbox
	sed -e '/\t\tpercent \\/ d' \
		-i regress/Makefile || die

	tc-export PKG_CONFIG
	local sed_args=(
		-e "s:-lcrypto:$(${PKG_CONFIG} --libs openssl):"
		# Disable fortify flags ... our gcc does this for us
		-e 's:-D_FORTIFY_SOURCE=2::'
	)

	# _XOPEN_SOURCE causes header conflicts on Solaris
	[[ ${CHOST} == *-solaris* ]] && sed_args+=(
		-e 's/-D_XOPEN_SOURCE//'
	)
	sed -i "${sed_args[@]}" configure{.ac,} || die

	eautoreconf
}

src_configure() {
	addwrite /dev/ptmx

	use debug && append-cppflags -DSANDBOX_SECCOMP_FILTER_DEBUG
	use static && append-ldflags -static
	use xmss && append-cflags -DWITH_XMSS

	if [[ ${CHOST} == *-solaris* ]] ; then
		# Solaris' glob.h doesn't have things like GLOB_TILDE, configure
		# doesn't check for this, so force the replacement to be put in
		# place
		append-cppflags -DBROKEN_GLOB
	fi

	# use replacement, RPF_ECHO_ON doesn't exist here
	[[ ${CHOST} == *-darwin* ]] && export ac_cv_func_readpassphrase=no

	local myconf=(
		--with-ldflags="${LDFLAGS}"
		--disable-strip
		--with-pid-dir="${EPREFIX}"$(usex kernel_linux '' '/var')/run
		--sysconfdir="${EPREFIX}"/etc/ssh
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)/misc
		--datadir="${EPREFIX}"/usr/share/openssh
		--with-privsep-path="${EPREFIX}"/var/empty
		--with-privsep-user=sshd
		# optional at runtime; guarantee a known path
		--with-xauth="${EPREFIX}"/usr/bin/xauth

		# --with-hardening adds the following in addition to flags we
		# already set in our toolchain:
		# * -ftrapv (which is broken with GCC anyway),
		# * -ftrivial-auto-var-init=zero (which is nice, but not the end of
		#    the world to not have)
		# * -fzero-call-used-regs=used (history of miscompilations with
		#    Clang (bug #872548), ICEs on m68k (bug #920350, gcc PR113086,
		#    gcc PR104820, gcc PR104817, gcc PR110934)).
		#
		# Furthermore, OSSH_CHECK_CFLAG_COMPILE does not use AC_CACHE_CHECK,
		# so we cannot just disable -fzero-call-used-regs=used.
		#
		# Therefore, just pass --without-hardening, given it doesn't negate
		# our already hardened toolchain defaults, and avoids adding flags
		# which are known-broken in both Clang and GCC and haven't been
		# proven reliable.
		--without-hardening

		$(use_with audit audit linux)
		$(use_with kerberos kerberos5 "${EPREFIX}"/usr)
		$(use_with ldns)
		$(use_with libedit)
		$(use_with pam)
		$(use_with pie)
		$(use_with selinux)
		$(use_with security-key security-key-builtin)
		$(use_with ssl openssl)
		$(use_with ssl ssl-engine)
	)

	if use elibc_musl; then
		# musl defines bogus values for UTMP_FILE and WTMP_FILE (bug #753230)
		myconf+=( --disable-utmp --disable-wtmp )
	fi

	# Workaround for Clang 15 miscompilation with -fzero-call-used-regs=all
	# bug #869839 (https://github.com/llvm/llvm-project/issues/57692)
	tc-is-clang && myconf+=( --without-hardening )

	econf "${myconf[@]}"
}

src_test() {
	local tests=( compat-tests )
	local shell=$(egetshell "${UID}")
	if [[ ${shell} == */nologin ]] || [[ ${shell} == */false ]] ; then
		ewarn "Running the full OpenSSH testsuite requires a usable shell for the 'portage'"
		ewarn "user, so we will run a subset only."
		tests+=( interop-tests )
	else
		tests+=( tests )
	fi

	local -x SUDO= SSH_SK_PROVIDER= TEST_SSH_UNSAFE_PERMISSIONS=1
	mkdir -p "${HOME}"/.ssh || die
	emake -j1 "${tests[@]}" </dev/null
}

# Gentoo tweaks to default config files.
tweak_ssh_configs() {
	local locale_vars=(
		# These are language variables that POSIX defines.
		# http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap08.html#tag_08_02
		LANG LC_ALL LC_COLLATE LC_CTYPE LC_MESSAGES LC_MONETARY LC_NUMERIC LC_TIME

		# These are the GNU extensions.
		# https://www.gnu.org/software/autoconf/manual/html_node/Special-Shell-Variables.html
		LANGUAGE LC_ADDRESS LC_IDENTIFICATION LC_MEASUREMENT LC_NAME LC_PAPER LC_TELEPHONE
	)

	dodir /etc/ssh/ssh_config.d /etc/ssh/sshd_config.d
	cat <<-EOF >> "${ED}"/etc/ssh/ssh_config || die
	Include "${EPREFIX}/etc/ssh/ssh_config.d/*.conf"
	EOF
	cat <<-EOF >> "${ED}"/etc/ssh/sshd_config || die
	Include "${EPREFIX}/etc/ssh/sshd_config.d/*.conf"
	EOF

	cat <<-EOF >> "${ED}"/etc/ssh/ssh_config.d/9999999gentoo.conf || die
	# Send locale environment variables (bug #367017)
	SendEnv ${locale_vars[*]}

	# Send COLORTERM to match TERM (bug #658540)
	SendEnv COLORTERM
	EOF

	cat <<-EOF >> "${ED}"/etc/ssh/ssh_config.d/9999999gentoo-security.conf || die
	RevokedHostKeys "${EPREFIX}/etc/ssh/ssh_revoked_hosts"
	EOF

	cat <<-EOF >> "${ED}"/etc/ssh/ssh_revoked_hosts || die
	# https://github.blog/2023-03-23-we-updated-our-rsa-ssh-host-key/
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
	EOF

	cat <<-EOF >> "${ED}"/etc/ssh/sshd_config.d/9999999gentoo.conf || die
	# Allow client to pass locale environment variables (bug #367017)
	AcceptEnv ${locale_vars[*]}

	# Allow client to pass COLORTERM to match TERM (bug #658540)
	AcceptEnv COLORTERM
	EOF

	if use pam ; then
		cat <<-EOF >> "${ED}"/etc/ssh/sshd_config.d/9999999gentoo-pam.conf || die
		UsePAM yes
		# This interferes with PAM.
		PasswordAuthentication no
		# PAM can do its own handling of MOTD.
		PrintMotd no
		PrintLastLog no
		EOF
	fi

	if use livecd ; then
		cat <<-EOF >> "${ED}"/etc/ssh/sshd_config.d/9999999gentoo-livecd.conf || die
		# Allow root login with password on livecds.
		PermitRootLogin Yes
		EOF
	fi
}

src_install() {
	emake install-nokeys DESTDIR="${D}"
	fperms 600 /etc/ssh/sshd_config
	dobin contrib/ssh-copy-id
	newinitd "${FILESDIR}"/sshd-r1.initd sshd
	newconfd "${FILESDIR}"/sshd-r1.confd sshd

	if use pam; then
		newpamd "${FILESDIR}"/sshd.pam_include.2 sshd
	fi

	tweak_ssh_configs

	doman contrib/ssh-copy-id.1
	dodoc ChangeLog CREDITS OVERVIEW README* TODO sshd_config

	diropts -m 0700
	dodir /etc/skel/.ssh
	rmdir "${ED}"/var/empty || die

	systemd_dounit "${FILESDIR}"/sshd.socket
	systemd_newunit "${FILESDIR}"/sshd.service.1 sshd.service
	systemd_newunit "${FILESDIR}"/sshd_at.service.1 'sshd@.service'
}

pkg_preinst() {
	if ! use ssl && has_version "${CATEGORY}/${PN}[ssl]"; then
		show_ssl_warning=1
	fi
}

pkg_postinst() {
	# bug #139235
	optfeature "x11 forwarding" x11-apps/xauth

	local old_ver
	for old_ver in ${REPLACING_VERSIONS}; do
		if ver_test "${old_ver}" -lt "5.8_p1"; then
			elog "Starting with openssh-5.8p1, the server will default to a newer key"
			elog "algorithm (ECDSA).  You are encouraged to manually update your stored"
			elog "keys list as servers update theirs.  See ssh-keyscan(1) for more info."
		fi
		if ver_test "${old_ver}" -lt "7.0_p1"; then
			elog "Starting with openssh-6.7, support for USE=tcpd has been dropped by upstream."
			elog "Make sure to update any configs that you might have.  Note that xinetd might"
			elog "be an alternative for you as it supports USE=tcpd."
		fi
		if ver_test "${old_ver}" -lt "7.1_p1"; then #557388 #555518
			elog "Starting with openssh-7.0, support for ssh-dss keys were disabled due to their"
			elog "weak sizes.  If you rely on these key types, you can re-enable the key types by"
			elog "adding to your sshd_config or ~/.ssh/config files:"
			elog "	PubkeyAcceptedKeyTypes=+ssh-dss"
			elog "You should however generate new keys using rsa or ed25519."

			elog "Starting with openssh-7.0, the default for PermitRootLogin changed from 'yes'"
			elog "to 'prohibit-password'.  That means password auth for root users no longer works"
			elog "out of the box.  If you need this, please update your sshd_config explicitly."
		fi
		if ver_test "${old_ver}" -lt "7.6_p1"; then
			elog "Starting with openssh-7.6p1, openssh upstream has removed ssh1 support entirely."
			elog "Furthermore, rsa keys with less than 1024 bits will be refused."
		fi
		if ver_test "${old_ver}" -lt "7.7_p1"; then
			elog "Starting with openssh-7.7p1, we no longer patch openssh to provide LDAP functionality."
			elog "Install sys-auth/ssh-ldap-pubkey and use OpenSSH's \"AuthorizedKeysCommand\" option"
			elog "if you need to authenticate against LDAP."
			elog "See https://wiki.gentoo.org/wiki/SSH/LDAP_migration for more details."
		fi
		if ver_test "${old_ver}" -lt "8.2_p1"; then
			ewarn "After upgrading to openssh-8.2p1 please restart sshd, otherwise you"
			ewarn "will not be able to establish new sessions. Restarting sshd over a ssh"
			ewarn "connection is generally safe."
		fi
		if ver_test "${old_ver}" -lt "9.2_p1-r1" && systemd_is_booted; then
			ewarn "From openssh-9.2_p1-r1 the supplied systemd unit file defaults to"
			ewarn "'Restart=on-failure', which causes the service to automatically restart if it"
			ewarn "terminates with an unclean exit code or signal. This feature is useful for most users,"
			ewarn "but it can increase the vulnerability of the system in the event of a future exploit."
			ewarn "If you have a web-facing setup or are concerned about security, it is recommended to"
			ewarn "set 'Restart=no' in your sshd unit file."
		fi
	done

	if [[ -n ${show_ssl_warning} ]]; then
		elog "Be aware that by disabling openssl support in openssh, the server and clients"
		elog "no longer support dss/rsa/ecdsa keys.  You will need to generate ed25519 keys"
		elog "and update all clients/servers that utilize them."
	fi
}
