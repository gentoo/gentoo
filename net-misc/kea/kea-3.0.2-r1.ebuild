# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/isc.asc
inherit eapi9-ver flag-o-matic meson python-r1 systemd tmpfiles
inherit toolchain-funcs verify-sig

DESCRIPTION="High-performance production grade DHCPv4 & DHCPv6 server"
HOMEPAGE="https://www.isc.org/kea/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.isc.org/isc-projects/kea.git"
else
	SRC_URI="
		https://downloads.isc.org/isc/kea/${PV}/${P}.tar.xz
		!doc? ( https://codeberg.org/peter1010/kea-manpages/archive/kea-manpages-${PV}.tar.gz )
		verify-sig? ( https://downloads.isc.org/isc/kea/${PV}/${P}.tar.xz.asc )
	"
	KEYWORDS="amd64 arm arm64 ~x86"
fi

LICENSE="MPL-2.0"
SLOT="0"
IUSE="debug doc kerberos mysql +openssl postgres shell test"

REQUIRED_USE="shell? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	>=dev-libs/boost-1.66:=
	dev-libs/log4cplus:=
	kerberos? ( virtual/krb5 )
	mysql? (
		app-arch/zstd:=
		dev-db/mysql-connector-c:=
		dev-libs/openssl:=
		virtual/zlib:=
	)
	!openssl? ( dev-libs/botan:3=[boost] )
	openssl? ( dev-libs/openssl:0= )
	postgres? ( dev-db/postgresql:* )
	shell? ( ${PYTHON_DEPS} )
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-cpp/gtest )
"
RDEPEND="${COMMON_DEPEND}
	acct-group/dhcp
	acct-user/dhcp
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-build/meson-1.8
	virtual/pkgconfig
	doc? (
		$(python_gen_any_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		')
	)
	verify-sig? ( sec-keys/openpgp-keys-isc )
"

PATCHES=(
	"${FILESDIR}"/kea-3.0.1-boost-1.89.patch
)

python_check_deps() {
	use doc || return 0;
	python_has_version "dev-python/sphinx[${PYTHON_USEDEP}]" \
		"dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python_setup
}

src_unpack() {
	use verify-sig && verify-sig_verify_detached "${DISTDIR}"/${P}.tar.xz{,.asc}

	default
}

src_prepare() {
	default

	# Fix up all doc paths, whether or not we are installing full set of docs
	sed -e "s:'doc/kea':'doc/${PF}':" \
		-i meson.build || die
	sed -e "s:'share/doc/kea':'share/doc/${PF}':" \
		-i doc/meson.build || die
	sed -e "s:'doc/kea':'doc/${PF}':" \
		-i doc/sphinx/meson.build || die
	sed -e "s:share/doc/kea/:share/doc/${PF}/:" \
		-i doc/sphinx/arm/install.rst || die
	sed -e "s:share/doc/kea/examples:share/doc/${PF}/examples:" \
		-i doc/sphinx/arm/config.rst || die

	# set shebang before meson whether or not we are installing the shell
	sed -e 's:^#!@PYTHON@:#!/usr/bin/env python3:' \
		-i src/bin/shell/kea-shell.in || die

	# Don't allow meson to install shell, we shall do that if required
	sed -e 's:install\: true:install\: false:' \
		-i src/bin/shell/meson.build || die

	# do not create /run
	sed -e '/^install_emptydir(RUNSTATEDIR)$/d' \
		-i meson.build || die
}

src_configure() {
	# https://bugs.gentoo.org/861617
	# https://gitlab.isc.org/isc-projects/kea/-/issues/3946
	#
	# Kea Devs say no to LTO
	filter-lto

	if use !openssl; then
		append-cxxflags -std=c++20
	fi

	# Note: https://gitlab.isc.org/isc-projects/kea/-/issues/4171 suggests patching meson.build to set umask,
	# instead here we pass install-umask as an argument to do the same thing, i.e. control permissions on
	# installed files.
	local emesonargs=(
		--localstatedir="${EPREFIX}/var"
		-Drunstatedir="${EPREFIX}/run"
		$(meson_feature kerberos krb5)
		-Dnetconf=disabled
		-Dcrypto=$(usex openssl openssl botan)
		$(meson_feature mysql)
		$(meson_feature postgres postgresql)
		$(meson_feature test tests)
		--install-umask=0o023
	)
	if use debug; then
		emesonargs+=(
			--debug
		)
	fi
	meson_src_configure
}

src_compile() {
	meson_src_compile

	use doc && meson_src_compile doc
}

src_test() {
	# Get list of all test suites into an associative array
	# the meson test --list returns either "kea / test_suite", "kea:shell-tests / test_suite" or
	# "kea:python-tests / test_suite"
	# Discard the shell tests as we can't run shell tests in sandbox

	pushd "${BUILD_DIR}" || die
	local -A TEST_SUITES
	while IFS=" / " read -r subsystem test_suite ; do
		if [[ ${subsystem} != "kea:shell-tests" ]]; then
			TEST_SUITES["$test_suite"]=1
		fi
	done < <(meson test --list || die)
	popd

	# Some other tests will fail for interface access restrictions, we have to remove the test suites those tests
	# belong to
	local SKIP_TESTS=(
		dhcp-radius-tests
		kea-log-buffer_logger_test.sh
		kea-log-console_test.sh
		dhcp-lease-query-tests
		kea-dhcp6-tests
		kea-dhcp4-tests
		kea-dhcp-tests
	)

	# skip shell tests that require a running instance of MySQL
	if use mysql; then
		SKIP_TESTS+=(
			kea-mysql-tests
			dhcp-mysql-lib-tests
			dhcp-forensic-log-libloadtests
		)
	fi

	# skip shell tests that require a running instance of PgSQL
	if use postgres; then
		SKIP_TESTS+=(
			kea-pgsql-tests
			dhcp-pgsql-lib-tests
			dhcp-forensic-log-libloadtests
		)
	fi

	if use kerberos; then
		SKIP_TESTS+=(
			ddns-gss-tsig-tests
		)
	fi

	if [[ $(tc-get-ptr-size) -eq 4 ]]; then
		# see https://bugs.gentoo.org/958171 for reason for skipping these tests
		SKIP_TESTS+=(
			kea-util-tests
			kea-dhcpsrv-tests
			dhcp-ha-lib-tests
			kea-d2-tests
		)
	fi

	for SKIP in ${SKIP_TESTS[@]}; do
		unset TEST_SUITES["${SKIP}"]
	done

	meson_src_test ${!TEST_SUITES[@]}
}

install_shell() {
	python_domodule ${ORIG_BUILD_DIR}/src/bin/shell/*.py
	python_doscript ${ORIG_BUILD_DIR}/src/bin/shell/kea-shell

	# fix path to import kea modules
	sed -e "/^sys.path.append/s|(.*)|('$(python_get_sitedir)/${PN}')|"	\
		-i "${ED}"/usr/lib/python-exec/${EPYTHON}/kea-shell || die
}

src_install() {
	meson_install

	# Tidy up
	rm -r "${ED}"/usr/share/kea/meson-info || die
	if use !mysql; then
		rm -r "${ED}"/usr/share/kea/scripts/mysql || die
	fi
	if use !postgres; then
		rm -r "${ED}"/usr/share/kea/scripts/pgsql || die
	fi

	# No easy way to control how meson_install sets permissions in meson < 1.9
	# So make sure permissions are same as in previous versions of kea
	# To avoid any differences between an update vers first time install
	fperms -R 0755 /usr/sbin
	fperms -R 0755 /usr/bin
	fperms -R 0755 /usr/$(get_libdir)

	if use shell; then
		python_moduleinto ${PN}
		ORIG_BUILD_DIR=${BUILD_DIR} python_foreach_impl install_shell
	fi

	# We don't use keactrl.conf so move to reduce confusion
	mv "${ED}"/etc/${PN}/keactrl.conf "${ED}"/usr/share/doc/${PF}/examples/keactrl.conf || die

	fowners -R root:dhcp /etc/${PN}

	# A side effect of using install_umask 023 in meson setup is setting config files to be world readable
	# lets not do that
	fperms -R 0640 /etc/${PN}

	# Install a conf per service and a linked init script per service
	newinitd "${FILESDIR}"/${PN}-initd-r3 ${PN}
	local svc
	for svc in dhcp4 dhcp6 dhcp-ddns ctrl-agent; do
		newconfd "${FILESDIR}"/${PN}-confd-r3 kea-${svc}
		sed -e "s:@KEA_SVC@:${svc}:g" \
			-i "${ED}"/etc/conf.d/kea-${svc} || die
		dosym kea "${EPREFIX}"/etc/init.d/kea-${svc}
	done

	if use !doc; then
		doman "${WORKDIR}"/kea-manpages/man/*
	fi

	systemd_newunit "${FILESDIR}"/${PN}-ctrl-agent.service-r2 ${PN}-ctrl-agent.service
	systemd_newunit "${FILESDIR}"/${PN}-dhcp-ddns.service-r2 ${PN}-dhcp-ddns.service
	systemd_newunit "${FILESDIR}"/${PN}-dhcp4.service-r2 ${PN}-dhcp4.service
	systemd_newunit "${FILESDIR}"/${PN}-dhcp6.service-r2 ${PN}-dhcp6.service

	newtmpfiles "${FILESDIR}"/${PN}.tmpfiles.conf ${PN}.conf

	keepdir /var/lib/${PN} /var/log/${PN}
	fowners -R dhcp:dhcp /var/lib/${PN} /var/log/${PN}
	fperms 750 /var/lib/${PN} /var/log/${PN}
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf

	if ver_replacing -lt 2.6; then
		ewarn "Several changes have been made for daemons:"
		ewarn "  To comply with common practices for this package,"
		ewarn "  config paths by default has been changed as below:"
		ewarn "    /etc/kea/kea-dhcp4.conf"
		ewarn "    /etc/kea/kea-dhcp6.conf"
		ewarn "    /etc/kea/kea-dhcp-ddns.conf"
		ewarn "    /etc/kea/kea-ctrl-agent.conf"
		ewarn
		ewarn "  Daemons are launched by default with the unprivileged user 'dhcp'"
		ewarn
		ewarn "Please check your configuration!"
	fi

	if ver_replacing -lt 3.0; then
		ewarn "Make sure that ${EPREFIX}/var/lib/kea and all the files in it are owned by dhcp:"
		ewarn "chown -R dhcp:dhcp ${EPREFIX}/var/lib/kea"
		ewarn
		ewarn "If using openrc;"
		ewarn "  There are now separate conf.d scripts and associated init.d per daemon!"
		ewarn "    Each Daemon needs to be launched separately, i.e. the daemons are"
		ewarn "      kea-dhcp4"
		ewarn "      kea-dhcp6"
		ewarn "      kea-dhcp-ddns"
		ewarn "      kea-ctrl"
		ewarn "Please adjust your service startups appropriately"
	fi

	if ! has_version net-misc/kea; then
		elog "See examples of config files in:"
		elog "  ${EROOT}/usr/share/doc/${PF}/examples"
	fi
}
