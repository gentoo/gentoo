# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=(python2_7)
inherit eutils prefix user python-r1 multilib multilib-minimal systemd s6

DESCRIPTION="NSS module for name lookups using LDAP"
HOMEPAGE="http://arthurdejong.org/nss-pam-ldapd/"
SRC_URI="http://arthurdejong.org/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug kerberos +pam sasl test +utils"

COMMON_DEP="
	net-nds/openldap[${MULTILIB_USEDEP}]
	sasl? ( dev-libs/cyrus-sasl[${MULTILIB_USEDEP}] )
	kerberos? ( virtual/krb5[${MULTILIB_USEDEP}] )
	pam? ( virtual/pam[${MULTILIB_USEDEP}] )
	utils? ( ${PYTHON_DEPS} )
	!sys-auth/nss_ldap
	!sys-auth/pam_ldap"
RDEPEND="${COMMON_DEP}"
DEPEND="${COMMON_DEP}
	test? (
		${PYTHON_DEPS}
		dev-python/pylint[${PYTHON_USEDEP}]
	)
	sys-devel/automake"

REQUIRED_USE="
	utils? ( ${PYTHON_REQUIRED_USE} )
	test? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	enewgroup nslcd
	enewuser nslcd -1 -1 -1 nslcd
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.9.4-disable-py3-only-linters.patch
	epatch_user
	use utils && python_setup
}

multilib_src_configure() {
	local -a myconf

	myconf=(
		--disable-utils
		--enable-warnings
		--with-ldap-lib=openldap
		--with-ldap-conf-file=/etc/nslcd.conf
		--with-nslcd-pidfile=/run/nslcd/nslcd.pid
		--with-nslcd-socket=/run/nslcd/socket
		$(usex x86-fbsd '--with-nss-flavour=' '--with-nss-flavour=' 'freebsd' 'glibc')
		$(use_enable debug)
		$(use_enable kerberos)
		$(use_enable pam)
		$(use_enable sasl)
	)

	# nss libraries always go in /lib on Gentoo
	if multilib_is_native_abi ; then
		myconf+=("--with-pam-seclib-dir=${EPREFIX}/$(get_libdir)/security")
		myconf+=("--libdir=${EPREFIX}/$(get_libdir)")
	else
		myconf+=("--with-pam-seclib-dir=/$(get_libdir)/security")
		myconf+=("--libdir=/$(get_libdir)")
	fi

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install_all() {
	local script

	newinitd "${FILESDIR}"/nslcd-init-r1 nslcd
	newinitd "${FILESDIR}"/nslcd-init-r2 nslcd
	newinitd "${FILESDIR}"/nslcd-init-s6 nslcd-s6
	s6_install_service nslcd "${FILESDIR}"/nslcd-run-s6

	insinto /usr/share/nss-pam-ldapd
	doins "${WORKDIR}/${P}/nslcd.conf"

	fperms o-r /etc/nslcd.conf

	if use utils; then
		python_moduleinto nslcd
		python_foreach_impl && python_domodule utils/*.py

		for script in chsh getent; do
			python_foreach_impl python_newscript utils/${script}.py ${script}.ldap
		done
	fi

	systemd_newtmpfilesd "${FILESDIR}"/nslcd-tmpfiles.conf nslcd.conf
	systemd_dounit "${FILESDIR}"/nslcd.service
}

multilib_src_test() {
	python_foreach_impl emake check
}

pkg_postinst() {
	echo
	elog "For this to work you must configure /etc/nslcd.conf"
	elog "This configuration is similar to pam_ldap's /etc/ldap.conf"
	echo
	elog "In order to use nss-pam-ldapd, nslcd needs to be running. You can"
	elog "start it like this:"
	elog "  # /etc/init.d/nslcd start"
	echo
	elog "You can add it to the default runlevel like so:"
	elog " # rc-update add nslcd default"
	elog
	elog "If you have >=sys-apps/openrc-0.16.3, you can also use s6"
	elog "to supervise this service."
	elog "To do this, emerge sys-apps/s6 then add nslcd-s6"
	elog "default runlevel instead of nslcd."
	elog
	elog "If you are upgrading, keep in mind that /etc/nss-ldapd.conf"
	elog " is now named /etc/nslcd.conf"
	echo
}
