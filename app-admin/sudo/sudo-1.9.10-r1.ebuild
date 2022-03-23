# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pam libtool tmpfiles toolchain-funcs

MY_P="${P/_/}"
MY_P="${MY_P/beta/b}"

DESCRIPTION="Allows users or groups to run commands as other users"
HOMEPAGE="https://www.sudo.ws/"
if [[ ${PV} == "9999" ]] ; then
	inherit mercurial
	EHG_REPO_URI="https://www.sudo.ws/repos/sudo"
else
	uri_prefix=
	case ${P} in
		*_beta*|*_rc*) uri_prefix=beta/ ;;
	esac

	SRC_URI="https://www.sudo.ws/sudo/dist/${uri_prefix}${MY_P}.tar.gz
		ftp://ftp.sudo.ws/pub/sudo/${uri_prefix}${MY_P}.tar.gz"
	if [[ ${PV} != *_beta* ]] && [[ ${PV} != *_rc* ]] ; then
		KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~sparc-solaris"
	fi
fi

# Basic license is ISC-style as-is, some files are released under
# 3-clause BSD license
LICENSE="ISC BSD"
SLOT="0"
IUSE="gcrypt ldap nls offensive pam sasl +secure-path selinux +sendmail skey ssl sssd"

DEPEND="
	sys-libs/zlib:=
	virtual/libcrypt:=
	gcrypt? ( dev-libs/libgcrypt:= )
	ldap? (
		>=net-nds/openldap-2.1.30-r1:=
		sasl? (
			dev-libs/cyrus-sasl
			net-nds/openldap:=[sasl]
		)
	)
	pam? ( sys-libs/pam )
	sasl? ( dev-libs/cyrus-sasl )
	skey? ( >=sys-auth/skey-1.1.5-r1 )
	ssl? ( dev-libs/openssl:0= )
	sssd? ( sys-auth/sssd[sudo] )
"
RDEPEND="
	${DEPEND}
	>=app-misc/editor-wrapper-3
	virtual/editor
	ldap? ( dev-lang/perl )
	pam? ( sys-auth/pambase )
	selinux? ( sec-policy/selinux-sudo )
	sendmail? ( virtual/mta )
"
BDEPEND="
	sys-devel/bison
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

REQUIRED_USE="
	?? ( pam skey )
	?? ( gcrypt ssl )
"

MAKEOPTS+=" SAMPLES="

src_prepare() {
	default
	elibtoolize
}

set_secure_path() {
	# first extract the default ROOTPATH from build env
	SECURE_PATH=$(unset ROOTPATH; . "${EPREFIX}"/etc/profile.env;
		echo "${ROOTPATH}")
		case "${SECURE_PATH}" in
			*/usr/sbin*) ;;
			*) SECURE_PATH=$(unset PATH;
				. "${EPREFIX}"/etc/profile.env; echo "${PATH}")
				;;
		esac
	if [[ -z ${SECURE_PATH} ]] ; then
		ewarn "	Failed to detect SECURE_PATH, please report this"
	fi

	# then remove duplicate path entries
	cleanpath() {
		local newpath thisp IFS=:
		for thisp in $1 ; do
			if [[ :${newpath}: != *:${thisp}:* ]] ; then
				newpath+=:${thisp}
			else
				einfo "   Duplicate entry ${thisp} removed..."
			fi
		done
		SECURE_PATH=${newpath#:}
	}
	cleanpath /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin${SECURE_PATH:+:${SECURE_PATH}}

	# finally, strip gcc paths #136027
	rmpath() {
		local e newpath thisp IFS=:
		for thisp in ${SECURE_PATH} ; do
			for e ; do [[ ${thisp} == ${e} ]] && continue 2 ; done
			newpath+=:${thisp}
		done
		SECURE_PATH=${newpath#:}
	}
	rmpath '*/gcc-bin/*' '*/gnat-gcc-bin/*' '*/gnat-gcc/*'
}

src_configure() {
	local SECURE_PATH
	set_secure_path
	tc-export PKG_CONFIG #767712

	# audit: somebody got to explain me how I can test this before I
	# enable it.. - Diego
	# plugindir: autoconf code is crappy and does not delay evaluation
	# until `make` time, so we have to use a full path here rather than
	# basing off other values.
	myeconfargs=(
		# requires some python eclass
		--disable-python
		--enable-tmpfiles.d="${EPREFIX}"/usr/lib/tmpfiles.d
		--enable-zlib=system
		--with-editor="${EPREFIX}"/usr/libexec/editor
		--with-env-editor
		--with-plugindir="${EPREFIX}"/usr/$(get_libdir)/sudo
		--with-rundir="${EPREFIX}"/run/sudo
		--with-vardir="${EPREFIX}"/var/db/sudo
		--without-linux-audit
		--without-opie
		$(use_enable gcrypt)
		$(use_enable nls)
		$(use_enable sasl)
		$(use_enable ssl openssl)
		$(use_with ldap)
		$(use_with ldap ldap_conf_file /etc/ldap.conf.sudo)
		$(use_with offensive insults)
		$(use_with offensive all-insults)
		$(use_with pam)
		$(use_with pam pam-login)
		$(use_with secure-path secure-path "${SECURE_PATH}")
		$(use_with selinux)
		$(use_with sendmail)
		$(use_with skey)
		$(use_with sssd)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if use ldap ; then
		dodoc README.LDAP.md

		cat <<-EOF > "${T}"/ldap.conf.sudo
		# See ldap.conf(5) and README.LDAP.md for details
		# This file should only be readable by root

		# supported directives: host, port, ssl, ldap_version
		# uri, binddn, bindpw, sudoers_base, sudoers_debug
		# tls_{checkpeer,cacertfile,cacertdir,randfile,ciphers,cert,key}
		EOF

		if use sasl ; then
			cat <<-EOF >> "${T}"/ldap.conf.sudo

			# SASL directives: use_sasl, sasl_mech, sasl_auth_id
			# sasl_secprops, rootuse_sasl, rootsasl_auth_id, krb5_ccname
			EOF
		fi

		insinto /etc
		doins "${T}"/ldap.conf.sudo
		fperms 0440 /etc/ldap.conf.sudo

		insinto /etc/openldap/schema
		newins docs/schema.OpenLDAP sudo.schema
	fi

	if use pam; then
		pamd_mimic system-auth sudo auth account session
		pamd_mimic system-auth sudo-i auth account session
	fi

	keepdir /var/db/sudo/lectured
	fperms 0700 /var/db/sudo/lectured
	fperms 0711 /var/db/sudo #652958

	# Don't install into /run as that is a tmpfs most of the time
	# (bug #504854)
	rm -rf "${ED}"/run || die

	find "${ED}" -type f -name "*.la" -delete || die #697812
}

pkg_postinst() {
	tmpfiles_process sudo.conf

	#652958
	local sudo_db="${EROOT}/var/db/sudo"
	if [[ "$(stat -c %a "${sudo_db}")" -ne 711 ]] ; then
		chmod 711 "${sudo_db}" || die
	fi

	if use ldap ; then
		ewarn
		ewarn "sudo uses the /etc/ldap.conf.sudo file for ldap configuration."
		ewarn
		if grep -qs '^[[:space:]]*sudoers:' "${ROOT}"/etc/nsswitch.conf ; then
			ewarn "In 1.7 series, LDAP is no more consulted, unless explicitly"
			ewarn "configured in /etc/nsswitch.conf."
			ewarn
			ewarn "To make use of LDAP, add this line to your /etc/nsswitch.conf:"
			ewarn "  sudoers: ldap files"
			ewarn
		fi
	fi
	if use prefix ; then
		ewarn
		ewarn "To use sudo, you need to change file ownership and permissions"
		ewarn "with root privileges, as follows:"
		ewarn
		ewarn "  # chown root:root ${EPREFIX}/usr/bin/sudo"
		ewarn "  # chown root:root ${EPREFIX}/usr/lib/sudo/sudoers.so"
		ewarn "  # chown root:root ${EPREFIX}/etc/sudoers"
		ewarn "  # chown root:root ${EPREFIX}/etc/sudoers.d"
		ewarn "  # chown root:root ${EPREFIX}/var/db/sudo"
		ewarn "  # chmod 4111 ${EPREFIX}/usr/bin/sudo"
		ewarn
	fi

	elog "To use the -A (askpass) option, you need to install a compatible"
	elog "password program from the following list. Starred packages will"
	elog "automatically register for the use with sudo (but will not force"
	elog "the -A option):"
	elog ""
	elog " [*] net-misc/ssh-askpass-fullscreen"
	elog "     net-misc/x11-ssh-askpass"
	elog ""
	elog "You can override the choice by setting the SUDO_ASKPASS environmnent"
	elog "variable to the program you want to use."
}
