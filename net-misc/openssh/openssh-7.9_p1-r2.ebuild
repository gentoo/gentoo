# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user flag-o-matic multilib autotools pam systemd

# Make it more portable between straight releases
# and _p? releases.
PARCH=${P/_}
#HPN_PV="${PV^^}"
HPN_PV="7.8_P1"

HPN_VER="14.16"
HPN_PATCHES=(
	${PN}-${HPN_PV/./_}-hpn-DynWinNoneSwitch-${HPN_VER}.diff
	${PN}-${HPN_PV/./_}-hpn-AES-CTR-${HPN_VER}.diff
)
HPN_DISABLE_MTAES=1 # unit tests hang on MT-AES-CTR
SCTP_VER="1.1" SCTP_PATCH="${PARCH}-sctp-${SCTP_VER}.patch.xz"
X509_VER="11.6" X509_PATCH="${PARCH}+x509-${X509_VER}.diff.gz"

DESCRIPTION="Port of OpenBSD's free SSH release"
HOMEPAGE="https://www.openssh.com/"
SRC_URI="mirror://openbsd/OpenSSH/portable/${PARCH}.tar.gz
	${SCTP_PATCH:+sctp? ( https://dev.gentoo.org/~chutzpah/dist/openssh/${SCTP_PATCH} )}
	${HPN_VER:+hpn? ( $(printf "mirror://sourceforge/hpnssh/HPN-SSH%%20${HPN_VER/./v}%%20${HPN_PV/_}/%s\n" "${HPN_PATCHES[@]}") )}
	${X509_PATCH:+X509? ( https://roumenpetrov.info/openssh/x509-${X509_VER}/${X509_PATCH} )}
	"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
# Probably want to drop ssl defaulting to on in a future version.
IUSE="abi_mips_n32 audit bindist debug hpn kerberos kernel_linux ldns libedit libressl livecd pam +pie sctp selinux +ssl static test X X509"
RESTRICT="!test? ( test )"
REQUIRED_USE="ldns? ( ssl )
	pie? ( !static )
	static? ( !kerberos !pam )
	X509? ( !sctp ssl )
	test? ( ssl )"

LIB_DEPEND="
	audit? ( sys-process/audit[static-libs(+)] )
	ldns? (
		net-libs/ldns[static-libs(+)]
		!bindist? ( net-libs/ldns[ecdsa,ssl(+)] )
		bindist? ( net-libs/ldns[-ecdsa,ssl(+)] )
	)
	libedit? ( dev-libs/libedit:=[static-libs(+)] )
	sctp? ( net-misc/lksctp-tools[static-libs(+)] )
	selinux? ( >=sys-libs/libselinux-1.28[static-libs(+)] )
	ssl? (
		!libressl? (
			|| (
				(
					>=dev-libs/openssl-1.0.1:0[bindist=]
					<dev-libs/openssl-1.1.0:0[bindist=]
				)
				>=dev-libs/openssl-1.1.0g:0[bindist=]
			)
			dev-libs/openssl:0=[static-libs(+)]
		)
		libressl? ( dev-libs/libressl:0=[static-libs(+)] )
	)
	>=sys-libs/zlib-1.2.3:=[static-libs(+)]"
RDEPEND="
	!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	pam? ( virtual/pam )
	kerberos? ( virtual/krb5 )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )
	virtual/pkgconfig
	virtual/os-headers
	sys-devel/autoconf"
RDEPEND="${RDEPEND}
	pam? ( >=sys-auth/pambase-20081028 )
	userland_GNU? ( virtual/shadow )
	X? ( x11-apps/xauth )"

S="${WORKDIR}/${PARCH}"

pkg_pretend() {
	# this sucks, but i'd rather have people unable to `emerge -u openssh`
	# than not be able to log in to their server any more
	maybe_fail() { [[ -z ${!2} ]] && echo "$1" ; }
	local fail="
		$(use hpn && maybe_fail hpn HPN_VER)
		$(use sctp && maybe_fail sctp SCTP_PATCH)
		$(use X509 && maybe_fail X509 X509_PATCH)
	"
	fail=$(echo ${fail})
	if [[ -n ${fail} ]] ; then
		eerror "Sorry, but this version does not yet support features"
		eerror "that you requested:	 ${fail}"
		eerror "Please mask ${PF} for now and check back later:"
		eerror " # echo '=${CATEGORY}/${PF}' >> /etc/portage/package.mask"
		die "booooo"
	fi

	# Make sure people who are using tcp wrappers are notified of its removal. #531156
	if grep -qs '^ *sshd *:' "${EROOT%/}"/etc/hosts.{allow,deny} ; then
		ewarn "Sorry, but openssh no longer supports tcp-wrappers, and it seems like"
		ewarn "you're trying to use it.  Update your ${EROOT}etc/hosts.{allow,deny} please."
	fi
}

src_prepare() {
	sed -i \
		-e "/_PATH_XAUTH/s:/usr/X11R6/bin/xauth:${EPREFIX%/}/usr/bin/xauth:" \
		pathnames.h || die

	# don't break .ssh/authorized_keys2 for fun
	sed -i '/^AuthorizedKeysFile/s:^:#:' sshd_config || die

	eapply "${FILESDIR}"/${PN}-7.9_p1-openssl-1.0.2-compat.patch
	eapply "${FILESDIR}"/${PN}-7.9_p1-include-stdlib.patch
	eapply "${FILESDIR}"/${PN}-7.8_p1-GSSAPI-dns.patch #165444 integrated into gsskex
	eapply "${FILESDIR}"/${PN}-6.7_p1-openssl-ignore-status.patch
	eapply "${FILESDIR}"/${PN}-7.5_p1-disable-conch-interop-tests.patch
	eapply "${FILESDIR}"/${PN}-7.9_p1-CVE-2018-20685.patch

	local PATCHSET_VERSION_MACROS=()

	if use X509 ; then
		pushd "${WORKDIR}" || die
		eapply "${FILESDIR}/${P}-X509-glue-${X509_VER}.patch"
		eapply "${FILESDIR}/${P}-X509-dont-make-piddir-${X509_VER}.patch"
		popd || die

		eapply "${WORKDIR}"/${X509_PATCH%.*}
		eapply "${FILESDIR}"/${P}-X509-${X509_VER}-tests.patch

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

		einfo "Disabling know failing test (cfgparse) caused by SCTP patch ..."
		sed -i \
			-e "/\t\tcfgparse \\\/d" \
			"${S}"/regress/Makefile || die "Failed to disable known failing test (cfgparse) caused by SCTP patch"
	fi

	if use hpn ; then
		local hpn_patchdir="${T}/${P}-hpn${HPN_VER}"
		mkdir "${hpn_patchdir}"
		cp $(printf -- "${DISTDIR}/%s\n" "${HPN_PATCHES[@]}") "${hpn_patchdir}"
		pushd "${hpn_patchdir}"
		eapply "${FILESDIR}"/${P}-hpn-glue.patch
		use X509 && eapply "${FILESDIR}"/${P}-hpn-X509-glue.patch
		use sctp && eapply "${FILESDIR}"/${P}-hpn-sctp-glue.patch
		popd

		eapply "${hpn_patchdir}"
		eapply "${FILESDIR}/openssh-7.9_p1-hpn-openssl-1.1.patch"

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

	[[ -d ${WORKDIR}/patch ]] && eapply "${WORKDIR}"/patch

	eapply_user #473004

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

	local myconf=(
		--with-ldflags="${LDFLAGS}"
		--disable-strip
		--with-pid-dir="${EPREFIX}"$(usex kernel_linux '' '/var')/run
		--sysconfdir="${EPREFIX%/}"/etc/ssh
		--libexecdir="${EPREFIX%/}"/usr/$(get_libdir)/misc
		--datadir="${EPREFIX%/}"/usr/share/openssh
		--with-privsep-path="${EPREFIX%/}"/var/empty
		--with-privsep-user=sshd
		$(use_with audit audit linux)
		$(use_with kerberos kerberos5 "${EPREFIX%/}"/usr)
		# We apply the sctp patch conditionally, so can't pass --without-sctp
		# unconditionally else we get unknown flag warnings.
		$(use sctp && use_with sctp)
		$(use_with ldns)
		$(use_with libedit)
		$(use_with pam)
		$(use_with pie)
		$(use_with selinux)
		$(use_with ssl openssl)
		$(use_with ssl md5-passwords)
		$(use_with ssl ssl-engine)
		$(use_with !elibc_Cygwin hardening) #659210
	)

	# stackprotect is broken on musl x86
	use elibc_musl && use x86 && myconf+=( --without-stackprotect )

	# The seccomp sandbox is broken on x32, so use the older method for now. #553748
	use amd64 && [[ ${ABI} == "x32" ]] && myconf+=( --with-sandbox=rlimit )

	econf "${myconf[@]}"
}

src_test() {
	local t skipped=() failed=() passed=()
	local tests=( interop-tests compat-tests )

	local shell=$(egetshell "${UID}")
	if [[ ${shell} == */nologin ]] || [[ ${shell} == */false ]] ; then
		elog "Running the full OpenSSH testsuite requires a usable shell for the 'portage'"
		elog "user, so we will run a subset only."
		skipped+=( tests )
	else
		tests+=( tests )
	fi

	# It will also attempt to write to the homedir .ssh.
	local sshhome=${T}/homedir
	mkdir -p "${sshhome}"/.ssh
	for t in "${tests[@]}" ; do
		# Some tests read from stdin ...
		HOMEDIR="${sshhome}" HOME="${sshhome}" \
		emake -k -j1 ${t} </dev/null \
			&& passed+=( "${t}" ) \
			|| failed+=( "${t}" )
	done

	einfo "Passed tests: ${passed[*]}"
	[[ ${#skipped[@]} -gt 0 ]] && ewarn "Skipped tests: ${skipped[*]}"
	[[ ${#failed[@]}  -gt 0 ]] && die "Some tests failed: ${failed[*]}"
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
	cat <<-EOF >> "${ED%/}"/etc/ssh/sshd_config

	# Allow client to pass locale environment variables. #367017
	AcceptEnv ${locale_vars[*]}

	# Allow client to pass COLORTERM to match TERM. #658540
	AcceptEnv COLORTERM
	EOF

	# Then the client config.
	cat <<-EOF >> "${ED%/}"/etc/ssh/ssh_config

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
			"${ED%/}"/etc/ssh/sshd_config || die
	fi

	if use livecd ; then
		sed -i \
			-e '/^#PermitRootLogin/c# Allow root login with password on livecds.\nPermitRootLogin Yes' \
			"${ED%/}"/etc/ssh/sshd_config || die
	fi
}

src_install() {
	emake install-nokeys DESTDIR="${D}"
	fperms 600 /etc/ssh/sshd_config
	dobin contrib/ssh-copy-id
	newinitd "${FILESDIR}"/sshd.initd sshd
	newconfd "${FILESDIR}"/sshd-r1.confd sshd

	newpamd "${FILESDIR}"/sshd.pam_include.2 sshd

	tweak_ssh_configs

	doman contrib/ssh-copy-id.1
	dodoc CREDITS OVERVIEW README* TODO sshd_config
	use hpn && dodoc HPN-README
	use X509 || dodoc ChangeLog

	diropts -m 0700
	dodir /etc/skel/.ssh

	keepdir /var/empty

	systemd_dounit "${FILESDIR}"/sshd.{service,socket}
	systemd_newunit "${FILESDIR}"/sshd_at.service 'sshd@.service'
}

pkg_preinst() {
	enewgroup sshd 22
	enewuser sshd 22 -1 /var/empty sshd
}

pkg_postinst() {
	if has_version "<${CATEGORY}/${PN}-5.8_p1" ; then
		elog "Starting with openssh-5.8p1, the server will default to a newer key"
		elog "algorithm (ECDSA).  You are encouraged to manually update your stored"
		elog "keys list as servers update theirs.  See ssh-keyscan(1) for more info."
	fi
	if has_version "<${CATEGORY}/${PN}-7.0_p1" ; then
		elog "Starting with openssh-6.7, support for USE=tcpd has been dropped by upstream."
		elog "Make sure to update any configs that you might have.  Note that xinetd might"
		elog "be an alternative for you as it supports USE=tcpd."
	fi
	if has_version "<${CATEGORY}/${PN}-7.1_p1" ; then #557388 #555518
		elog "Starting with openssh-7.0, support for ssh-dss keys were disabled due to their"
		elog "weak sizes.  If you rely on these key types, you can re-enable the key types by"
		elog "adding to your sshd_config or ~/.ssh/config files:"
		elog "	PubkeyAcceptedKeyTypes=+ssh-dss"
		elog "You should however generate new keys using rsa or ed25519."

		elog "Starting with openssh-7.0, the default for PermitRootLogin changed from 'yes'"
		elog "to 'prohibit-password'.  That means password auth for root users no longer works"
		elog "out of the box.  If you need this, please update your sshd_config explicitly."
	fi
	if has_version "<${CATEGORY}/${PN}-7.6_p1" ; then
		elog "Starting with openssh-7.6p1, openssh upstream has removed ssh1 support entirely."
		elog "Furthermore, rsa keys with less than 1024 bits will be refused."
	fi
	if has_version "<${CATEGORY}/${PN}-7.7_p1" ; then
		elog "Starting with openssh-7.7p1, we no longer patch openssh to provide LDAP functionality."
		elog "Install sys-auth/ssh-ldap-pubkey and use OpenSSH's \"AuthorizedKeysCommand\" option"
		elog "if you need to authenticate against LDAP."
		elog "See https://wiki.gentoo.org/wiki/SSH/LDAP_migration for more details."
	fi
	if ! use ssl && has_version "${CATEGORY}/${PN}[ssl]" ; then
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
