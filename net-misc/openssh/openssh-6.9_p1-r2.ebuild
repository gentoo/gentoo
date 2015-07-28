# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/openssh/openssh-6.9_p1-r2.ebuild,v 1.11 2015/07/28 01:08:12 vapier Exp $

EAPI="4"
inherit eutils user flag-o-matic multilib autotools pam systemd versionator

# Make it more portable between straight releases
# and _p? releases.
PARCH=${P/_}

HPN_PATCH="${PN}-6.9p1-r1-hpnssh14v5.tar.xz"
LDAP_PATCH="${PN}-lpk-6.8p1-0.3.14.patch.xz"
X509_VER="8.4" X509_PATCH="${PN}-6.9p1+x509-${X509_VER}.diff.gz"

DESCRIPTION="Port of OpenBSD's free SSH release"
HOMEPAGE="http://www.openssh.org/"
SRC_URI="mirror://openbsd/OpenSSH/portable/${PARCH}.tar.gz
	mirror://gentoo/${PN}-6.8_p1-sctp.patch.xz
	${HPN_PATCH:+hpn? (
		mirror://gentoo/${HPN_PATCH}
		http://dev.gentoo.org/~polynomial-c/${HPN_PATCH}
		mirror://sourceforge/hpnssh/${HPN_PATCH}
	)}
	${LDAP_PATCH:+ldap? ( mirror://gentoo/${LDAP_PATCH} )}
	${X509_PATCH:+X509? ( http://roumenpetrov.info/openssh/x509-${X509_VER}/${X509_PATCH} )}
	"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~arm-linux ~x86-linux"
# Probably want to drop ssl defaulting to on in a future version.
IUSE="bindist debug ${HPN_PATCH:++}hpn kerberos kernel_linux ldap ldns libedit pam +pie sctp selinux skey ssh1 +ssl static X X509"
REQUIRED_USE="ldns? ( ssl )
	pie? ( !static )
	ssh1? ( ssl )
	static? ( !kerberos !pam )
	X509? ( !ldap ssl )"

LIB_DEPEND="
	ldns? (
		net-libs/ldns[static-libs(+)]
		!bindist? ( net-libs/ldns[ecdsa,ssl] )
		bindist? ( net-libs/ldns[-ecdsa,ssl] )
	)
	libedit? ( dev-libs/libedit[static-libs(+)] )
	sctp? ( net-misc/lksctp-tools[static-libs(+)] )
	selinux? ( >=sys-libs/libselinux-1.28[static-libs(+)] )
	skey? ( >=sys-auth/skey-1.1.5-r1[static-libs(+)] )
	ssl? (
		>=dev-libs/openssl-0.9.6d:0[bindist=]
		dev-libs/openssl[static-libs(+)]
	)
	>=sys-libs/zlib-1.2.3[static-libs(+)]"
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

S=${WORKDIR}/${PARCH}

pkg_setup() {
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
		eerror "Sorry, but openssh no longer supports tcp-wrappers, and it seems like"
		eerror "you're trying to use it.  Update your ${EROOT}etc/hosts.{allow,deny} please."
		die "USE=tcpd no longer works"
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

	# don't break .ssh/authorized_keys2 for fun
	sed -i '/^AuthorizedKeysFile/s:^:#:' sshd_config || die

	if use X509 ; then
		pushd .. >/dev/null
		#epatch "${WORKDIR}"/${PN}-6.8_p1-x509-${X509_VER}-glue.patch
		epatch "${FILESDIR}"/${PN}-6.8_p1-sctp-x509-glue.patch
		popd >/dev/null
		epatch "${WORKDIR}"/${X509_PATCH%.*}
		epatch "${FILESDIR}"/${PN}-6.3_p1-x509-hpn14v2-glue.patch
		epatch "${FILESDIR}"/${PN}-6.9_p1-x509-warnings.patch
		save_version X509
	fi
	if use ldap ; then
		epatch "${WORKDIR}"/${LDAP_PATCH%.*}
		save_version LPK
	fi
	epatch "${FILESDIR}"/${PN}-4.7_p1-GSSAPI-dns.patch #165444 integrated into gsskex
	epatch "${FILESDIR}"/${PN}-6.7_p1-openssl-ignore-status.patch
	# The X509 patchset fixes this independently.
	use X509 || epatch "${FILESDIR}"/${PN}-6.8_p1-ssl-engine-configure.patch
	epatch "${WORKDIR}"/${PN}-6.8_p1-sctp.patch
	if use hpn ; then
		EPATCH_FORCE="yes" EPATCH_SUFFIX="patch" \
			EPATCH_MULTI_MSG="Applying HPN patchset ..." \
			epatch "${WORKDIR}"/${HPN_PATCH%.*.*}
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
	sed -i "${sed_args[@]}" configure{.ac,} || die

	epatch_user #473004

	# Now we can build a sane merged version.h
	(
		sed '/^#define SSH_RELEASE/d' version.h.* | sort -u
		macros=()
		for p in HPN LPK X509 ; do [ -e version.h.${p} ] && macros+=( SSH_${p} ) ; done
		printf '#define SSH_RELEASE SSH_VERSION SSH_PORTABLE %s\n' "${macros}"
	) > version.h

	eautoreconf
}

src_configure() {
	addwrite /dev/ptmx
	addpredict /etc/skey/skeykeys # skey configure code triggers this

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
		$(use_with kerberos kerberos5 "${EPREFIX}"/usr)
		# We apply the ldap patch conditionally, so can't pass --without-ldap
		# unconditionally else we get unknown flag warnings.
		$(use ldap && use_with ldap)
		$(use_with ldns)
		$(use_with libedit)
		$(use_with pam)
		$(use_with pie)
		$(use_with sctp)
		$(use_with selinux)
		$(use_with skey)
		$(use_with ssh1)
		# The X509 patch deletes this option entirely.
		$(use X509 || use_with ssl openssl)
		$(use_with ssl md5-passwords)
		$(use_with ssl ssl-engine)
	)

	# Special settings for Gentoo/FreeBSD 9.0 or later (see bug #391011)
	if use elibc_FreeBSD && version_is_at_least 9.0 "$(uname -r|sed 's/\(.\..\).*/\1/')" ; then
		myconf+=( --disable-utmp --disable-wtmp --disable-wtmpx )
		append-ldflags -lutil
	fi

	econf "${myconf[@]}"
}

src_install() {
	emake install-nokeys DESTDIR="${D}"
	fperms 600 /etc/ssh/sshd_config
	dobin contrib/ssh-copy-id
	newinitd "${FILESDIR}"/sshd.rc6.4 sshd
	newconfd "${FILESDIR}"/sshd.confd sshd
	keepdir /var/empty

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

	if ! use X509 && [[ -n ${LDAP_PATCH} ]] && use ldap ; then
		insinto /etc/openldap/schema/
		newins openssh-lpk_openldap.schema openssh-lpk.schema
	fi

	doman contrib/ssh-copy-id.1
	dodoc ChangeLog CREDITS OVERVIEW README* TODO sshd_config

	diropts -m 0700
	dodir /etc/skel/.ssh

	systemd_dounit "${FILESDIR}"/sshd.{service,socket}
	systemd_newunit "${FILESDIR}"/sshd_at.service 'sshd@.service'
}

src_test() {
	local t tests skipped failed passed shell
	tests="interop-tests compat-tests"
	skipped=""
	shell=$(egetshell ${UID})
	if [[ ${shell} == */nologin ]] || [[ ${shell} == */false ]] ; then
		elog "Running the full OpenSSH testsuite"
		elog "requires a usable shell for the 'portage'"
		elog "user, so we will run a subset only."
		skipped="${skipped} tests"
	else
		tests="${tests} tests"
	fi
	# It will also attempt to write to the homedir .ssh
	local sshhome=${T}/homedir
	mkdir -p "${sshhome}"/.ssh
	for t in ${tests} ; do
		# Some tests read from stdin ...
		HOMEDIR="${sshhome}" \
		emake -k -j1 ${t} </dev/null \
			&& passed="${passed}${t} " \
			|| failed="${failed}${t} "
	done
	einfo "Passed tests: ${passed}"
	ewarn "Skipped tests: ${skipped}"
	if [[ -n ${failed} ]] ; then
		ewarn "Failed tests: ${failed}"
		die "Some tests failed: ${failed}"
	else
		einfo "Failed tests: ${failed}"
		return 0
	fi
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
	if has_version "<${CATEGORY}/${PN}-6.9_p1" ; then
		elog "Starting with openssh-6.9p1, ssh1 support is disabled by default."
	fi
	ewarn "Remember to merge your config files in /etc/ssh/ and then"
	ewarn "reload sshd: '/etc/init.d/sshd reload'."
	elog "Note: openssh-6.7 versions no longer support USE=tcpd as upstream has"
	elog "      dropped it.  Make sure to update any configs that you might have."
}
