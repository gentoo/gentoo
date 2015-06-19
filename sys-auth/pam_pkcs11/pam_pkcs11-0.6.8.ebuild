# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_pkcs11/pam_pkcs11-0.6.8.ebuild,v 1.4 2015/04/02 17:46:27 mr_bones_ Exp $

EAPI=4

inherit multilib pam

DESCRIPTION="PKCS#11 PAM library"
HOMEPAGE="https://github.com/opensc/pam_pkcs11/wiki"
SRC_URI="mirror://sourceforge/opensc/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="curl ldap nss +pcsc-lite"

RDEPEND="sys-libs/pam
	curl? ( net-misc/curl )
	ldap? ( net-nds/openldap )
	nss? (
		dev-libs/nss
		curl? ( || ( net-misc/curl[-ssl] net-misc/curl[ssl,curl_ssl_nss] ) )
	)
	!nss? (
		dev-libs/openssl
		curl? ( || ( net-misc/curl[-ssl] net-misc/curl[ssl,-curl_ssl_nss] ) )
	)
	pcsc-lite? ( sys-apps/pcsc-lite )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# Fix the example files to be somewhat decent, and usable as
	# default configuration
	sed -i \
		-e '/try_first_pass/s:false:true:' \
		-e '/debug =/s:true:false:' \
		-e 's:\(/usr\|\${exec_prefix}\)/lib/:/usr/'$(get_libdir)/':g' \
		etc/pam_pkcs11.conf.example.in \
		etc/pkcs11_eventmgr.conf.example || die "sed failed"
}

src_configure() {
	econf \
		$(use_with curl) \
		$(use_with pcsc-lite pcsclite) \
		$(use_with ldap) \
		$(use_with nss) \
		--docdir=/usr/share/doc/${PF} \
		--htmldir=/usr/share/doc/${PF}/html \
		--disable-silent-rules
}

src_install() {
	emake DESTDIR="${D}" pamdir="$(getpam_mod_dir)" install

	# These are all dlopened plugins, so .la files are useless.
	find "${D}" -name '*.la' -delete || die

	dodoc AUTHORS ChangeLog ChangeLog.svn NEWS README TODO doc/README.*
	dohtml doc/api/*

	# Provide some basic configuration
	keepdir /etc/pam_pkcs11{,/{cacerts,crl}}

	insinto /etc/pam_pkcs11
	newins etc/pam_pkcs11.conf.example pam_pkcs11.conf
	newins etc/pkcs11_eventmgr.conf.example pkcs11_eventmgr.conf
}

pkg_config() {
	local dir
	for dir in "${EROOT}"etc/${PN}/{cacerts,crl}; do
		pushd "${dir}" > /dev/null
		ebegin "Creating hash links in '${dir}'"
		"${EROOT}usr/bin/pkcs11_make_hash_link" || die
		eend $?
		popd > /dev/null
	done
}

pkg_postinst() {
	elog "For ${PN} to work you need a PKCS#11 provider, such as one of:"
	elog "  - dev-libs/opensc"
	elog "  - dev-libs/opencryptoki"
	elog ""
	elog "You probably want to configure the '${EROOT}etc/${PN}/${PN}.conf' file with"
	elog "the settings for your pkcs11 provider."
	elog ""
	elog "You might also want to set up '${EROOT}etc/${PN}/pkcs11_eventmgr.conf' with"
	elog "the settings for the event manager, and start it up at user login."
}

# TODO list!
#
# - we need to find a way allow the user to choose whether to start the
#   event manager at _all_ the logins, and if that's the case, lock all
#   kind of sessions (terminal _and_ X);
# - upstream should probably migrate the configuration of the event
#   manager on a per-user basis, since it makes little sense to be _all_
#   system-level configuration;
# - we should probably provide some better config support that ensures
#   the configuration to be valid, as well as creating the symlinks;
# - we should probably add support for nss;
# - we should move the configuration in /etc/security as for the rest
#   of PAM-related configuration.
