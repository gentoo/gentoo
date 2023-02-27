# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit autotools python-r1 s6 systemd tmpfiles multilib-minimal

DESCRIPTION="NSS module for name lookups using LDAP"
HOMEPAGE="https://arthurdejong.org/nss-pam-ldapd/"
SRC_URI="https://arthurdejong.org/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 x86"
IUSE="debug kerberos +pam pynslcd sasl test +utils"
REQUIRED_USE="
	utils? ( ${PYTHON_REQUIRED_USE} )
	test? ( ${PYTHON_REQUIRED_USE} pynslcd )
"
RESTRICT="!test? ( test )"

RDEPEND="
	acct-group/nslcd
	acct-user/nslcd
	net-nds/openldap:=[${MULTILIB_USEDEP}]
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
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	test? ( dev-python/pylint[${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}"/nss-pam-ldapd-0.9.4-disable-py3-only-linters.patch
	"${FILESDIR}"/nss-pam-ldapd-0.9.11-use-mkstemp.patch
	"${FILESDIR}"/nss-pam-ldapd-0.9.11-relative-imports.patch
	"${FILESDIR}"/nss-pam-ldapd-0.9.11-tests.patch
	"${FILESDIR}"/nss-pam-ldapd-0.9.11-tests-py39.patch
)

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && python_setup
}

src_prepare() {
	default

	touch pynslcd/__init__.py || die "Could not create __init__.py for pynslcd"
	mv pynslcd/pynslcd.py pynslcd/main.py || die

	eautoreconf
}

multilib_src_configure() {
	local myconf=(
		--disable-utils
		--enable-warnings
		--with-ldap-lib=openldap
		--with-ldap-conf-file="${EPREFIX}"/etc/nslcd.conf
		--with-nslcd-pidfile=/run/nslcd/nslcd.pid
		--with-nslcd-socket=/run/nslcd/socket
		--with-nss-flavour=glibc
		$(use_enable pynslcd)
		$(use_enable debug)
		$(use_enable kerberos)
		$(use_enable pam)
		$(use_enable sasl)

		# nss libraries always go in /lib on Gentoo
		--with-pam-seclib-dir="${EPREFIX}"/$(get_libdir)/security
		--libdir="${EPREFIX}"/$(get_libdir)
	)
	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_test() {
	python_test() {
		cp -l "${S}"/pynslcd/*.py pynslcd/ || die "Could not copy python files for tests"
		nonfatal emake check || die "tests failed with ${EPYTHON}"
	}

	pushd "${BUILD_DIR}" >/dev/null || die
	ln -s ../pynslcd/constants.py utils/constants.py || die
	python_foreach_impl python_test
	popd >/dev/null || die
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if use pynslcd; then
		python_moduleinto pynslcd
		python_foreach_impl python_domodule pynslcd/*.py
	fi
}

multilib_src_install_all() {
	einstalldocs

	newinitd "${FILESDIR}"/nslcd.init nslcd
	s6_install_service nslcd "${FILESDIR}"/nslcd.s6

	insinto /usr/share/nss-pam-ldapd
	doins "${WORKDIR}"/${P}/nslcd.conf

	fperms o-r /etc/nslcd.conf

	if use utils; then
		python_moduleinto nslcd
		python_foreach_impl python_domodule utils/*.py

		local script
		for script in chsh getent; do
			python_foreach_impl python_newscript utils/${script}.py ${script}.ldap
		done
	fi
	if use pynslcd; then
		rm -rf "${ED}"/usr/share/pynslcd || die
		python_moduleinto pynslcd
		python_foreach_impl python_domodule pynslcd/*.py
		python_scriptinto /usr/sbin
		python_foreach_impl python_newscript pynslcd/main.py pynslcd
		newinitd "${FILESDIR}"/pynslcd.init pynslcd
	fi

	newtmpfiles "${FILESDIR}"/nslcd-tmpfiles.conf nslcd.conf
	systemd_newunit "${FILESDIR}"/nslcd.service nslcd.service
}

pkg_postinst() {
	tmpfiles_process nslcd.conf

	elog "For this to work you must configure /etc/nslcd.conf"
	elog "This configuration is similar to pam_ldap's /etc/ldap.conf"
	elog
	elog "In order to use nss-pam-ldapd, nslcd needs to be running. You can"
	elog "start it like this:"
	elog "  # /etc/init.d/nslcd start"
	elog
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
}
