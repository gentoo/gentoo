# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_{7..8})
inherit eutils prefix python-r1 autotools multilib multilib-minimal systemd s6 tmpfiles

DESCRIPTION="NSS module for name lookups using LDAP"
HOMEPAGE="https://arthurdejong.org/nss-pam-ldapd/"
SRC_URI="https://arthurdejong.org/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug kerberos +pam pynslcd sasl test +utils"
RESTRICT="!test? ( test )"

COMMON_DEP="
	acct-group/nslcd
	acct-user/nslcd
	net-nds/openldap[${MULTILIB_USEDEP}]
	sasl? ( dev-libs/cyrus-sasl[${MULTILIB_USEDEP}] )
	kerberos? ( virtual/krb5[${MULTILIB_USEDEP}] )
	sys-libs/pam[${MULTILIB_USEDEP}]
	utils? ( ${PYTHON_DEPS} )
	pynslcd? (
		dev-python/python-ldap[${PYTHON_USEDEP}]
		dev-python/python-daemon[${PYTHON_USEDEP}]
	)
	!sys-auth/nss_ldap
	!sys-auth/pam_ldap
"
RDEPEND="${COMMON_DEP}"
DEPEND="${COMMON_DEP}
	test? (
		${PYTHON_DEPS}
		dev-python/pylint[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	${PYTHON_DEPS}
	sys-devel/automake
"

REQUIRED_USE="
	utils? ( ${PYTHON_REQUIRED_USE} )
	test? ( ${PYTHON_REQUIRED_USE} pynslcd )
"

PATCHES=(
	"${FILESDIR}/nss-pam-ldapd-0.9.4-disable-py3-only-linters.patch"
	"${FILESDIR}/nss-pam-ldapd-0.9.11-use-mkstemp.patch"
	"${FILESDIR}/nss-pam-ldapd-0.9.11-relative-imports.patch"
	"${FILESDIR}/nss-pam-ldapd-0.9.11-tests.patch"
)

src_prepare() {
	default
	use utils && python_setup
	touch pynslcd/__init__.py || die "Could not create __init__.py for pynslcd"
	mv pynslcd/pynslcd.py pynslcd/main.py || die

	eautoreconf
}

multilib_src_configure() {
	local -a myconf=(
		--disable-utils
		--enable-warnings
		--with-ldap-lib=openldap
		--with-ldap-conf-file=/etc/nslcd.conf
		--with-nslcd-pidfile=/run/nslcd/nslcd.pid
		--with-nslcd-socket=/run/nslcd/socket
		$(usex x86-fbsd '--with-nss-flavour=' '--with-nss-flavour=' 'freebsd' 'glibc')
		$(use_enable pynslcd)
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

multilib_src_test() {
	pushd "${BUILD_DIR}" >/dev/null || die
	ln -s ../pynslcd/constants.py utils/constants.py || die
	python_foreach_impl python_test
	popd >/dev/null || die
}

python_test() {
	emake check
}

multilib_src_install_all() {
	local script

	newinitd "${FILESDIR}"/nslcd.init nslcd
	s6_install_service nslcd "${FILESDIR}"/nslcd.s6

	insinto /usr/share/nss-pam-ldapd
	doins "${WORKDIR}/${P}/nslcd.conf"

	fperms o-r /etc/nslcd.conf

	if use utils; then
		python_moduleinto nslcd
		python_foreach_impl python_domodule utils/*.py

		for script in chsh getent; do
			python_foreach_impl python_newscript utils/${script}.py ${script}.ldap
		done
	fi
	if use pynslcd; then
		rm -rf "${D}"/usr/share/pynslcd
		python_moduleinto pynslcd
		python_foreach_impl python_domodule pynslcd/*.py
		python_scriptinto /usr/sbin
		python_foreach_impl python_newscript pynslcd/main.py pynslcd
		newinitd "${FILESDIR}"/pynslcd.init pynslcd
	fi

	newtmpfiles "${FILESDIR}"/nslcd-tmpfiles.conf nslcd.conf
	systemd_newunit "${FILESDIR}"/nslcd.service nslcd.service
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if use pynslcd; then
		python_moduleinto pynslcd
		python_foreach_impl python_domodule pynslcd/*.py
	fi
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
