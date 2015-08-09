# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils pam multilib libtool

MY_P=${P/_/}
MY_P=${MY_P/beta/b}

uri_prefix=
case ${P} in
*_beta*|*_rc*) uri_prefix=beta/ ;;
esac

DESCRIPTION="Allows users or groups to run commands as other users"
HOMEPAGE="http://www.sudo.ws/"
SRC_URI="http://www.sudo.ws/sudo/dist/${uri_prefix}${MY_P}.tar.gz
	ftp://ftp.sudo.ws/pub/sudo/${uri_prefix}${MY_P}.tar.gz"

# Basic license is ISC-style as-is, some files are released under
# 3-clause BSD license
LICENSE="ISC BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~sparc-solaris"
IUSE="ldap nls pam offensive selinux skey +sendmail"

DEPEND="pam? ( virtual/pam )
	skey? ( >=sys-auth/skey-1.1.5-r1 )
	ldap? (
		>=net-nds/openldap-2.1.30-r1
		dev-libs/cyrus-sasl
	)
	sys-libs/zlib"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-sudo )
	ldap? ( dev-lang/perl )
	pam? ( sys-auth/pambase )
	>=app-misc/editor-wrapper-3
	virtual/editor
	sendmail? ( virtual/mta )"
DEPEND="${DEPEND}
	sys-devel/bison"

S=${WORKDIR}/${MY_P}

REQUIRED_USE="pam? ( !skey ) skey? ( !pam )"

MAKEOPTS+=" SAMPLES="

src_prepare() {
	epatch "${FILESDIR}"/${P}-include-sys-types-h.patch
	elibtoolize
}

set_rootpath() {
	# FIXME: secure_path is a compile time setting. using ROOTPATH
	# is not perfect, env-update may invalidate this, but until it
	# is available as a sudoers setting this will have to do.
	einfo "Setting secure_path ..."

	# first extract the default ROOTPATH from build env
	ROOTPATH=$(unset ROOTPATH; . "${EPREFIX}"/etc/profile.env; echo "${ROOTPATH}")
	if [[ -z ${ROOTPATH} ]] ; then
		ewarn "	Failed to find ROOTPATH, please report this"
	fi

	# then remove duplicate path entries
	cleanpath() {
		local newpath thisp IFS=:
		for thisp in $1 ; do
			if [[ :${newpath}: != *:${thisp}:* ]] ; then
				newpath+=:$thisp
			else
				einfo "   Duplicate entry ${thisp} removed..."
			fi
		done
		ROOTPATH=${newpath#:}
	}
	cleanpath /bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/opt/bin${ROOTPATH:+:${ROOTPATH}}

	# finally, strip gcc paths #136027
	rmpath() {
		local e newpath thisp IFS=:
		for thisp in ${ROOTPATH} ; do
			for e ; do [[ $thisp == $e ]] && continue 2 ; done
			newpath+=:$thisp
		done
		ROOTPATH=${newpath#:}
	}
	rmpath '*/gcc-bin/*' '*/gnat-gcc-bin/*' '*/gnat-gcc/*'

	einfo "... done"
}

src_configure() {
	local ROOTPATH
	set_rootpath

	# audit: somebody got to explain me how I can test this before I
	# enable it.. - Diego
	# plugindir: autoconf code is crappy and does not delay evaluation
	# until `make` time, so we have to use a full path here rather than
	# basing off other values.
	econf \
		--enable-zlib=system \
		--with-secure-path="${ROOTPATH}" \
		--with-editor="${EPREFIX}"/usr/libexec/editor \
		--with-env-editor \
		$(use_with offensive insults) \
		$(use_with offensive all-insults) \
		$(use_with ldap ldap_conf_file /etc/ldap.conf.sudo) \
		$(use_with ldap) \
		$(use_enable nls) \
		$(use_with pam) \
		$(use_with skey) \
		$(use_with selinux) \
		$(use_with sendmail) \
		--without-opie \
		--without-linux-audit \
		--with-rundir="${EPREFIX}"/var/run/sudo \
		--with-vardir="${EPREFIX}"/var/db/sudo \
		--with-plugindir="${EPREFIX}"/usr/$(get_libdir)/sudo \
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
}

src_install() {
	default

	if use ldap ; then
		dodoc README.LDAP doc/schema.OpenLDAP
		dosbin plugins/sudoers/sudoers2ldif

		cat <<-EOF > "${T}"/ldap.conf.sudo
		# See ldap.conf(5) and README.LDAP for details
		# This file should only be readable by root

		# supported directives: host, port, ssl, ldap_version
		# uri, binddn, bindpw, sudoers_base, sudoers_debug
		# tls_{checkpeer,cacertfile,cacertdir,randfile,ciphers,cert,key
		EOF

		insinto /etc
		doins "${T}"/ldap.conf.sudo
		fperms 0440 /etc/ldap.conf.sudo
	fi

	pamd_mimic system-auth sudo auth account session

	keepdir /var/db/sudo
	fperms 0700 /var/db/sudo

	# Don't install into /var/run as that is a tmpfs most of the time
	# (bug #504854)
	rm -rf "${D}"/var/run
}

pkg_postinst() {
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
