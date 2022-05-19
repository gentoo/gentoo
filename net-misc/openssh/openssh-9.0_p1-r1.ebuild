# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user-info flag-o-matic autotools pam systemd toolchain-funcs verify-sig

# Make it more portable between straight releases
# and _p? releases.
PARCH=${P/_}

# PV to USE for HPN patches
#HPN_PV="${PV^^}"
HPN_PV="8.5_P1"

HPN_VER="15.2"
HPN_PATCHES=(
	${PN}-${HPN_PV/./_}-hpn-DynWinNoneSwitch-${HPN_VER}.diff
	${PN}-${HPN_PV/./_}-hpn-AES-CTR-${HPN_VER}.diff
	${PN}-${HPN_PV/./_}-hpn-PeakTput-${HPN_VER}.diff
)

SCTP_VER="1.2" SCTP_PATCH="${PARCH}-sctp-${SCTP_VER}.patch.xz"
X509_VER="13.3.2" X509_PATCH="${PARCH}+x509-${X509_VER}.diff.gz"

DESCRIPTION="Port of OpenBSD's free SSH release"
HOMEPAGE="https://www.openssh.com/"
SRC_URI="mirror://openbsd/OpenSSH/portable/${PARCH}.tar.gz
	${SCTP_PATCH:+sctp? ( https://dev.gentoo.org/~chutzpah/dist/openssh/${SCTP_PATCH} )}
	${HPN_VER:+hpn? ( $(printf "mirror://sourceforge/project/hpnssh/Patches/HPN-SSH%%20${HPN_VER/./v}%%20${HPN_PV/_P/p}/%s\n" "${HPN_PATCHES[@]}") )}
	${X509_PATCH:+X509? ( https://roumenpetrov.info/openssh/x509-${X509_VER}/${X509_PATCH} )}
	verify-sig? ( mirror://openbsd/OpenSSH/portable/${PARCH}.tar.gz.asc )
"
VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/openssh.org.asc
S="${WORKDIR}/${PARCH}"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
# Probably want to drop ssl defaulting to on in a future version.
IUSE="abi_mips_n32 audit debug hpn kerberos ldns libedit livecd pam +pie sctp security-key selinux +ssl static test X X509 xmss"

RESTRICT="!test? ( test )"

REQUIRED_USE="
	hpn? ( ssl )
	ldns? ( ssl )
	pie? ( !static )
	static? ( !kerberos !pam )
	X509? ( !sctp ssl !xmss )
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
	sctp? ( net-misc/lksctp-tools[static-libs(+)] )
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
DEPEND="${RDEPEND}
	virtual/os-headers
	kernel_linux? ( !prefix-guest? ( >=sys-kernel/linux-headers-5.1 ) )
	static? ( ${LIB_DEPEND} )
"
RDEPEND="${RDEPEND}
	pam? ( >=sys-auth/pambase-20081028 )
	!prefix? ( sys-apps/shadow )
	X? ( x11-apps/xauth )
"
BDEPEND="
	virtual/pkgconfig
	sys-devel/autoconf
	verify-sig? ( sec-keys/openpgp-keys-openssh )
"

pkg_pretend() {
	# this sucks, but i'd rather have people unable to `emerge -u openssh`
	# than not be able to log in to their server any more
	local missing=()
	check_feature() { use "${1}" && [[ -z ${!2} ]] && missing+=( "${1}" ); }
	check_feature hpn HPN_VER
	check_feature sctp SCTP_PATCH
	check_feature X509 X509_PATCH
	if [[ ${#missing[@]} -ne 0 ]] ; then
		eerror "Sorry, but this version does not yet support features"
		eerror "that you requested: ${missing[*]}"
		eerror "Please mask ${PF} for now and check back later:"
		eerror " # echo '=${CATEGORY}/${PF}' >> /etc/portage/package.mask"
		die "Missing requested third party patch."
	fi

	# Make sure people who are using tcp wrappers are notified of its removal. #531156
	if grep -qs '^ *sshd *:' "${EROOT}"/etc/hosts.{allow,deny} ; then
		ewarn "Sorry, but openssh no longer supports tcp-wrappers, and it seems like"
		ewarn "you're trying to use it.  Update your ${EROOT}/etc/hosts.{allow,deny} please."
	fi
}

src_unpack() {
	default

	# We don't have signatures for HPN, X509, so we have to write this ourselves
	use verify-sig && verify-sig_verify_detached "${DISTDIR}"/${PARCH}.tar.gz{,.asc}
}

src_prepare() {
	sed -i \
		-e "/_PATH_XAUTH/s:/usr/X11R6/bin/xauth:${EPREFIX}/usr/bin/xauth:" \
		pathnames.h || die

	# don't break .ssh/authorized_keys2 for fun
	sed -i '/^AuthorizedKeysFile/s:^:#:' sshd_config || die

	eapply "${FILESDIR}"/${PN}-7.9_p1-include-stdlib.patch
	eapply "${FILESDIR}"/${PN}-8.7_p1-GSSAPI-dns.patch #165444 integrated into gsskex
	eapply "${FILESDIR}"/${PN}-6.7_p1-openssl-ignore-status.patch
	eapply "${FILESDIR}"/${PN}-7.5_p1-disable-conch-interop-tests.patch
	eapply "${FILESDIR}"/${PN}-8.0_p1-fix-putty-tests.patch
	eapply "${FILESDIR}"/${PN}-8.0_p1-deny-shmget-shmat-shmdt-in-preauth-privsep-child.patch
	eapply "${FILESDIR}"/${PN}-8.9_p1-allow-ppoll_time64.patch #834019
	eapply "${FILESDIR}"/${PN}-8.9_p1-gss-use-HOST_NAME_MAX.patch #834044

	[[ -d ${WORKDIR}/patches ]] && eapply "${WORKDIR}"/patches

	local PATCHSET_VERSION_MACROS=()

	if use X509 ; then
		pushd "${WORKDIR}" &>/dev/null || die
		eapply "${FILESDIR}/${P}-X509-glue-"${X509_VER}".patch"
		popd &>/dev/null || die

		eapply "${WORKDIR}"/${X509_PATCH%.*}
		eapply "${FILESDIR}/${PN}-9.0_p1-X509-uninitialized-delay.patch"

		# We need to patch package version or any X.509 sshd will reject our ssh client
		# with "userauth_pubkey: could not parse key: string is too large [preauth]"
		# error
		einfo "Patching package version for X.509 patch set ..."
		sed -i \
			-e "s/^AC_INIT(\[OpenSSH\], \[Portable\]/AC_INIT([OpenSSH], [${X509_VER}]/" \
			"${S}"/configure.ac || die "Failed to patch package version for X.509 patch"

		einfo "Patching version.h to expose X.509 patch set ..."
		sed -i \
			-e "/^#define SSH_PORTABLE.*/a #define SSH_X509               \"-PKIXSSH-${X509_VER}\"" \
			"${S}"/version.h || die "Failed to sed-in X.509 patch version"
		PATCHSET_VERSION_MACROS+=( 'SSH_X509' )
	fi

	if use sctp ; then
		eapply "${WORKDIR}"/${SCTP_PATCH%.*}

		einfo "Patching version.h to expose SCTP patch set ..."
		sed -i \
			-e "/^#define SSH_PORTABLE/a #define SSH_SCTP        \"-sctp-${SCTP_VER}\"" \
			"${S}"/version.h || die "Failed to sed-in SCTP patch version"
		PATCHSET_VERSION_MACROS+=( 'SSH_SCTP' )

		einfo "Disabling known failing test (cfgparse) caused by SCTP patch ..."
		sed -i \
			-e "/\t\tcfgparse \\\/d" \
			"${S}"/regress/Makefile || die "Failed to disable known failing test (cfgparse) caused by SCTP patch"
	fi

	if use hpn ; then
		local hpn_patchdir="${T}/${P}-hpn${HPN_VER}"
		mkdir "${hpn_patchdir}" || die
		cp $(printf -- "${DISTDIR}/%s\n" "${HPN_PATCHES[@]}") "${hpn_patchdir}" || die
		pushd "${hpn_patchdir}" &>/dev/null || die
		eapply "${FILESDIR}"/${PN}-8.9_p1-hpn-${HPN_VER}-glue.patch
		use X509 && eapply "${FILESDIR}"/${PN}-8.9_p1-hpn-${HPN_VER}-X509-glue.patch
		use sctp && eapply "${FILESDIR}"/${PN}-8.5_p1-hpn-${HPN_VER}-sctp-glue.patch
		popd &>/dev/null || die

		eapply "${hpn_patchdir}"

		use X509 || eapply "${FILESDIR}/openssh-8.6_p1-hpn-version.patch"

		einfo "Patching Makefile.in for HPN patch set ..."
		sed -i \
			-e "/^LIBS=/ s/\$/ -lpthread/" \
			"${S}"/Makefile.in || die "Failed to patch Makefile.in"

		einfo "Patching version.h to expose HPN patch set ..."
		sed -i \
			-e "/^#define SSH_PORTABLE/a #define SSH_HPN         \"-hpn${HPN_VER//./v}\"" \
			"${S}"/version.h || die "Failed to sed-in HPN patch version"
		PATCHSET_VERSION_MACROS+=( 'SSH_HPN' )

		if [[ -n "${HPN_DISABLE_MTAES}" ]] ; then
			einfo "Disabling known non-working MT AES cipher per default ..."

			cat > "${T}"/disable_mtaes.conf <<- EOF

			# HPN's Multi-Threaded AES CTR cipher is currently known to be broken
			# and therefore disabled per default.
			DisableMTAES yes
			EOF
			sed -i \
				-e "/^#HPNDisabled.*/r ${T}/disable_mtaes.conf" \
				"${S}"/sshd_config || die "Failed to disabled MT AES ciphers in sshd_config"

			sed -i \
				-e "/AcceptEnv.*_XXX_TEST$/a \\\tDisableMTAES\t\tyes" \
				"${S}"/regress/test-exec.sh || die "Failed to disable MT AES ciphers in test config"
		fi
	fi

	if use X509 || use sctp || use hpn ; then
		einfo "Patching sshconnect.c to use SSH_RELEASE in send_client_banner() ..."
		sed -i \
			-e "s/PROTOCOL_MAJOR_2, PROTOCOL_MINOR_2, SSH_VERSION/PROTOCOL_MAJOR_2, PROTOCOL_MINOR_2, SSH_RELEASE/" \
			"${S}"/sshconnect.c || die "Failed to patch send_client_banner() to use SSH_RELEASE (sshconnect.c)"

		einfo "Patching sshd.c to use SSH_RELEASE in sshd_exchange_identification() ..."
		sed -i \
			-e "s/PROTOCOL_MAJOR_2, PROTOCOL_MINOR_2, SSH_VERSION/PROTOCOL_MAJOR_2, PROTOCOL_MINOR_2, SSH_RELEASE/" \
			"${S}"/sshd.c || die "Failed to patch sshd_exchange_identification() to use SSH_RELEASE (sshd.c)"

		einfo "Patching version.h to add our patch sets to SSH_RELEASE ..."
		sed -i \
			-e "s/^#define SSH_RELEASE.*/#define SSH_RELEASE     SSH_VERSION SSH_PORTABLE ${PATCHSET_VERSION_MACROS[*]}/" \
			"${S}"/version.h || die "Failed to patch SSH_RELEASE (version.h)"
	fi

	sed -i \
		-e "/#UseLogin no/d" \
		"${S}"/sshd_config || die "Failed to remove removed UseLogin option (sshd_config)"

	eapply_user #473004

	# These tests are currently incompatible with PORTAGE_TMPDIR/sandbox
	sed -e '/\t\tpercent \\/ d' \
		-i regress/Makefile || die

	tc-export PKG_CONFIG
	local sed_args=(
		-e "s:-lcrypto:$(${PKG_CONFIG} --libs openssl):"
		# Disable PATH reset, trust what portage gives us #254615
		-e 's:^PATH=/:#PATH=/:'
		# Disable fortify flags ... our gcc does this for us
		-e 's:-D_FORTIFY_SOURCE=2::'
	)

	# The -ftrapv flag ICEs on hppa #505182
	use hppa && sed_args+=(
		-e '/CFLAGS/s:-ftrapv:-fdisable-this-test:'
		-e '/OSSH_CHECK_CFLAG_LINK.*-ftrapv/d'
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
		$(use_with audit audit linux)
		$(use_with kerberos kerberos5 "${EPREFIX}"/usr)
		# We apply the sctp patch conditionally, so can't pass --without-sctp
		# unconditionally else we get unknown flag warnings.
		$(use sctp && use_with sctp)
		$(use_with ldns)
		$(use_with libedit)
		$(use_with pam)
		$(use_with pie)
		$(use_with selinux)
		$(usex X509 '' "$(use_with security-key security-key-builtin)")
		$(use_with ssl openssl)
		$(use_with ssl ssl-engine)
		$(use_with !elibc_Cygwin hardening) #659210
	)

	if use elibc_musl; then
		# musl defines bogus values for UTMP_FILE and WTMP_FILE
		# https://bugs.gentoo.org/753230
		myconf+=( --disable-utmp --disable-wtmp )
	fi

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

	# First the server config.
	cat <<-EOF >> "${ED}"/etc/ssh/sshd_config

	# Allow client to pass locale environment variables. #367017
	AcceptEnv ${locale_vars[*]}

	# Allow client to pass COLORTERM to match TERM. #658540
	AcceptEnv COLORTERM
	EOF

	# Then the client config.
	cat <<-EOF >> "${ED}"/etc/ssh/ssh_config

	# Send locale environment variables. #367017
	SendEnv ${locale_vars[*]}

	# Send COLORTERM to match TERM. #658540
	SendEnv COLORTERM
	EOF

	if use pam ; then
		sed -i \
			-e "/^#UsePAM /s:.*:UsePAM yes:" \
			-e "/^#PasswordAuthentication /s:.*:PasswordAuthentication no:" \
			-e "/^#PrintMotd /s:.*:PrintMotd no:" \
			-e "/^#PrintLastLog /s:.*:PrintLastLog no:" \
			"${ED}"/etc/ssh/sshd_config || die
	fi

	if use livecd ; then
		sed -i \
			-e '/^#PermitRootLogin/c# Allow root login with password on livecds.\nPermitRootLogin Yes' \
			"${ED}"/etc/ssh/sshd_config || die
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
	dodoc CREDITS OVERVIEW README* TODO sshd_config
	use hpn && dodoc HPN-README
	use X509 || dodoc ChangeLog

	diropts -m 0700
	dodir /etc/skel/.ssh
	rmdir "${ED}"/var/empty || die

	systemd_dounit "${FILESDIR}"/sshd.{service,socket}
	systemd_newunit "${FILESDIR}"/sshd_at.service 'sshd@.service'
}

pkg_preinst() {
	if ! use ssl && has_version "${CATEGORY}/${PN}[ssl]"; then
		show_ssl_warning=1
	fi
}

pkg_postinst() {
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
	done

	if [[ -n ${show_ssl_warning} ]]; then
		elog "Be aware that by disabling openssl support in openssh, the server and clients"
		elog "no longer support dss/rsa/ecdsa keys.  You will need to generate ed25519 keys"
		elog "and update all clients/servers that utilize them."
	fi

	if use hpn && [[ -n "${HPN_DISABLE_MTAES}" ]] ; then
		elog ""
		elog "HPN's multi-threaded AES CTR cipher is currently known to be broken"
		elog "and therefore disabled at runtime per default."
		elog "Make sure your sshd_config is up to date and contains"
		elog ""
		elog "  DisableMTAES yes"
		elog ""
		elog "Otherwise you maybe unable to connect to this sshd using any AES CTR cipher."
		elog ""
	fi
}
