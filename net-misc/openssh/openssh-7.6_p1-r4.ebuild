# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user flag-o-matic multilib autotools pam systemd versionator

# Make it more portable between straight releases
# and _p? releases.
PARCH=${P/_}

HPN_PATCH="${PARCH}-hpnssh14v12-r1.tar.xz"
SCTP_PATCH="${PN}-7.6_p1-sctp.patch.xz"
LDAP_PATCH="${PN}-lpk-7.6p1-0.3.14.patch.xz"
X509_VER="11.2" X509_PATCH="${PN}-${PV/_}+x509-${X509_VER}.diff.gz"

DESCRIPTION="Port of OpenBSD's free SSH release"
HOMEPAGE="http://www.openssh.org/"
SRC_URI="mirror://openbsd/OpenSSH/portable/${PARCH}.tar.gz
	${SCTP_PATCH:+https://dev.gentoo.org/~polynomial-c/${SCTP_PATCH}}
	${HPN_PATCH:+hpn? ( https://dev.gentoo.org/~chutzpah/${HPN_PATCH} )}
	${LDAP_PATCH:+ldap? ( https://dev.gentoo.org/~polynomial-c/${LDAP_PATCH} )}
	${X509_PATCH:+X509? ( https://dev.gentoo.org/~chutzpah/${X509_PATCH} )}
	"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
# Probably want to drop ssl defaulting to on in a future version.
IUSE="abi_mips_n32 audit bindist debug hpn kerberos kernel_linux ldap ldns libedit libressl livecd pam +pie sctp selinux skey +ssl static test X X509"
REQUIRED_USE="ldns? ( ssl )
	pie? ( !static )
	static? ( !kerberos !pam )
	X509? ( !ldap !sctp ssl )
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
	skey? ( >=sys-auth/skey-1.1.5-r1[static-libs(+)] )
	ssl? (
		!libressl? (
			>=dev-libs/openssl-1.0.1:0=[bindist=]
			dev-libs/openssl:0=[static-libs(+)]
		)
		libressl? ( dev-libs/libressl:0=[static-libs(+)] )
	)
	>=sys-libs/zlib-1.2.3:=[static-libs(+)]"
RDEPEND="
	!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	pam? ( virtual/pam )
	kerberos? ( virtual/krb5 )
	ldap? ( net-nds/openldap )"
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
		$(use X509 && maybe_fail X509 X509_PATCH)
		$(use ldap && maybe_fail ldap LDAP_PATCH)
		$(use hpn && maybe_fail hpn HPN_PATCH)
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
	if grep -qs '^ *sshd *:' "${EROOT}"/etc/hosts.{allow,deny} ; then
		ewarn "Sorry, but openssh no longer supports tcp-wrappers, and it seems like"
		ewarn "you're trying to use it.  Update your ${EROOT}etc/hosts.{allow,deny} please."
	fi
}

save_version() {
	# version.h patch conflict avoidence
	mv version.h version.h.$1
	cp -f version.h.pristine version.h
}

src_prepare() {
	sed -i \
		-e "/_PATH_XAUTH/s:/usr/X11R6/bin/xauth:${EPREFIX}/usr/bin/xauth:" \
		pathnames.h || die
	# keep this as we need it to avoid the conflict between LPK and HPN changing
	# this file.
	cp version.h version.h.pristine

	eapply "${FILESDIR}/${P}-warnings.patch"

	# don't break .ssh/authorized_keys2 for fun
	sed -i '/^AuthorizedKeysFile/s:^:#:' sshd_config || die

	if use X509 ; then
		if use hpn ; then
			pushd "${WORKDIR}" >/dev/null
			eapply "${FILESDIR}"/${P}-hpn-x509-${X509_VER}-glue.patch
			eapply "${FILESDIR}"/${P}-x509-${X509_VER}-libressl.patch
			popd >/dev/null
			save_version X509
		fi
		eapply "${WORKDIR}"/${X509_PATCH%.*}
	fi

	if use ldap ; then
		eapply "${WORKDIR}"/${LDAP_PATCH%.*}
		save_version LPK
	fi

	eapply "${FILESDIR}"/${PN}-7.5_p1-GSSAPI-dns.patch #165444 integrated into gsskex
	eapply "${FILESDIR}"/${PN}-6.7_p1-openssl-ignore-status.patch
	use X509 || eapply "${WORKDIR}"/${SCTP_PATCH%.*}
	use abi_mips_n32 && eapply "${FILESDIR}"/${PN}-7.3-mips-seccomp-n32.patch

	if use hpn ; then
		elog "Applying HPN patchset ..."
		eapply "${WORKDIR}"/${HPN_PATCH%.*.*}
		save_version HPN
	fi

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

	eapply_user #473004

	# Now we can build a sane merged version.h
	(
		sed '/^#define SSH_RELEASE/d' version.h.* | sort -u
		macros=()
		for p in HPN LPK X509; do [[ -e version.h.${p} ]] && macros+=( SSH_${p} ) ; done
		printf '#define SSH_RELEASE SSH_VERSION SSH_PORTABLE %s\n' "${macros[*]}"
	) > version.h

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
		--sysconfdir="${EPREFIX}"/etc/ssh
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)/misc
		--datadir="${EPREFIX}"/usr/share/openssh
		--with-privsep-path="${EPREFIX}"/var/empty
		--with-privsep-user=sshd
		$(use_with audit audit linux)
		$(use_with kerberos kerberos5 "${EPREFIX}"/usr)
		# We apply the ldap patch conditionally, so can't pass --without-ldap
		# unconditionally else we get unknown flag warnings.
		$(use ldap && use_with ldap)
		$(use_with ldns)
		$(use_with libedit)
		$(use_with pam)
		$(use_with pie)
		$(use X509 || use_with sctp)
		$(use_with selinux)
		$(use_with skey)
		$(use_with ssl openssl)
		$(use_with ssl md5-passwords)
		$(use_with ssl ssl-engine)
	)

	# The seccomp sandbox is broken on x32, so use the older method for now. #553748
	use amd64 && [[ ${ABI} == "x32" ]] && myconf+=( --with-sandbox=rlimit )

	econf "${myconf[@]}"
}

src_install() {
	emake install-nokeys DESTDIR="${D}"
	fperms 600 /etc/ssh/sshd_config
	dobin contrib/ssh-copy-id
	newinitd "${FILESDIR}"/sshd.rc6.4 sshd
	newconfd "${FILESDIR}"/sshd.confd sshd

	newpamd "${FILESDIR}"/sshd.pam_include.2 sshd
	if use pam ; then
		sed -i \
			-e "/^#UsePAM /s:.*:UsePAM yes:" \
			-e "/^#PasswordAuthentication /s:.*:PasswordAuthentication no:" \
			-e "/^#PrintMotd /s:.*:PrintMotd no:" \
			-e "/^#PrintLastLog /s:.*:PrintLastLog no:" \
			"${ED}"/etc/ssh/sshd_config || die
	fi

	# Gentoo tweaks to default config files
	cat <<-EOF >> "${ED}"/etc/ssh/sshd_config

	# Allow client to pass locale environment variables #367017
	AcceptEnv LANG LC_*
	EOF
	cat <<-EOF >> "${ED}"/etc/ssh/ssh_config

	# Send locale environment variables #367017
	SendEnv LANG LC_*
	EOF

	if use livecd ; then
		sed -i \
			-e '/^#PermitRootLogin/c# Allow root login with password on livecds.\nPermitRootLogin Yes' \
			"${ED}"/etc/ssh/sshd_config || die
	fi

	if ! use X509 && [[ -n ${LDAP_PATCH} ]] && use ldap ; then
		insinto /etc/openldap/schema/
		newins openssh-lpk_openldap.schema openssh-lpk.schema
	fi

	doman contrib/ssh-copy-id.1
	dodoc CREDITS OVERVIEW README* TODO sshd_config
	use X509 || dodoc ChangeLog

	diropts -m 0700
	dodir /etc/skel/.ssh

	systemd_dounit "${FILESDIR}"/sshd.{service,socket}
	systemd_newunit "${FILESDIR}"/sshd_at.service 'sshd@.service'
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
	if ! use ssl && has_version "${CATEGORY}/${PN}[ssl]" ; then
		elog "Be aware that by disabling openssl support in openssh, the server and clients"
		elog "no longer support dss/rsa/ecdsa keys.  You will need to generate ed25519 keys"
		elog "and update all clients/servers that utilize them."
	fi

	# remove this if aes-ctr-mt gets fixed
	if use hpn; then
		elog "The multithreaded AES-CTR cipher has been temporarily dropped from the HPN patch"
		elog "set since it does not (yet) work with >=openssh-7.6p1."
	fi
}
