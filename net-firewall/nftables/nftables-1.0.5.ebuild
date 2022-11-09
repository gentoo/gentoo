# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{8..11} )
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/netfilter.org.asc
inherit edo linux-info distutils-r1 systemd verify-sig

DESCRIPTION="Linux kernel (3.13+) firewall, NAT and packet mangling tools"
HOMEPAGE="https://netfilter.org/projects/nftables/"

if [[ ${PV} =~ ^[9]{4,}$ ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://git.netfilter.org/${PN}"

	BDEPEND="
		sys-devel/bison
		sys-devel/flex
	"
else
	SRC_URI="https://netfilter.org/projects/nftables/files/${P}.tar.bz2
		verify-sig? ( https://netfilter.org/projects/nftables/files/${P}.tar.bz2.sig )"
	KEYWORDS="amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86"
	BDEPEND+="verify-sig? ( sec-keys/openpgp-keys-netfilter )"
fi

LICENSE="GPL-2"
SLOT="0/1"
IUSE="debug doc +gmp json libedit +modern-kernel python +readline static-libs test xtables"
RESTRICT="!test? ( test )"

RDEPEND="
	>=net-libs/libmnl-1.0.4:0=
	>=net-libs/libnftnl-1.2.3:0=
	gmp? ( dev-libs/gmp:= )
	json? ( dev-libs/jansson:= )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:= )
	xtables? ( >=net-firewall/iptables-1.6.1:= )
"

DEPEND="${RDEPEND}"

BDEPEND+="
	virtual/pkgconfig
	doc? (
		app-text/asciidoc
		>=app-text/docbook2X-0.8.8-r4
	)
	python? ( ${PYTHON_DEPS} )
"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	libedit? ( !readline )
"

pkg_setup() {
	if kernel_is ge 3 13; then
		if use modern-kernel && kernel_is lt 3 18; then
			eerror "The modern-kernel USE flag requires kernel version 3.18 or newer to work properly."
		fi
		CONFIG_CHECK="~NF_TABLES"
		linux-info_pkg_setup
	else
		eerror "This package requires kernel version 3.13 or newer to work properly."
	fi
}

src_prepare() {
	default

	if [[ ${PV} =~ ^[9]{4,}$ ]] ; then
		eautoreconf
	fi

	if use python; then
		pushd py >/dev/null || die
		distutils-r1_src_prepare
		popd >/dev/null || die
	fi
}

src_configure() {
	local myeconfargs=(
		# We handle python separately
		--disable-python
		--disable-static
		--sbindir="${EPREFIX}"/sbin
		$(use_enable debug)
		$(use_enable doc man-doc)
		$(use_with !gmp mini_gmp)
		$(use_with json)
		$(use_with libedit cli editline)
		$(use_with readline cli readline)
		$(use_enable static-libs static)
		$(use_with xtables)
	)
	econf "${myeconfargs[@]}"

	if use python; then
		pushd py >/dev/null || die
		distutils-r1_src_configure
		popd >/dev/null || die
	fi
}

src_compile() {
	default

	if use python; then
		pushd py >/dev/null || die
		distutils-r1_src_compile
		popd >/dev/null || die
	fi
}

src_test() {
	emake check

	if [[ ${EUID} == 0 ]]; then
		edo tests/shell/run-tests.sh -v
	else
		ewarn "Skipping shell tests (requires root)"
	fi

	# Need to rig up Python eclass if using this, but it doesn't seem to work
	# for me anyway.
	#cd tests/py || die
	#"${EPYTHON}" nft-test.py || die
}

src_install() {
	default

	if ! use doc && [[ ! ${PV} =~ ^[9]{4,}$ ]]; then
		pushd doc >/dev/null || die
		doman *.?
		popd >/dev/null || die
	fi

	# Do it here instead of in src_prepare to avoid eautoreconf
	# rmdir lets us catch if more files end up installed in /etc/nftables
	dodir /usr/share/doc/${PF}/skels/
	mv "${ED}"/etc/nftables/osf "${ED}"/usr/share/doc/${PF}/skels/osf || die
	rmdir "${ED}"/etc/nftables || die

	local mksuffix="$(usex modern-kernel '-mk' '')"

	exeinto /usr/libexec/${PN}
	newexe "${FILESDIR}"/libexec/${PN}${mksuffix}.sh ${PN}.sh
	newconfd "${FILESDIR}"/${PN}${mksuffix}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}${mksuffix}.init-r1 ${PN}
	keepdir /var/lib/nftables

	systemd_dounit "${FILESDIR}"/systemd/${PN}-restore.service

	if use python ; then
		pushd py >/dev/null || die
		distutils-r1_src_install
		popd >/dev/null || die
	fi

	find "${ED}" -type f -name "*.la" -delete || die
}

pkg_preinst() {
	if [[ -d /sys/module/nf_tables ]] && [[ -x /sbin/nft ]] && [[ -z ${ROOT} ]]; then
		if ! /sbin/nft -t list ruleset | "${ED}"/sbin/nft -c -f -; then
			eerror "Your currently loaded ruleset cannot be parsed by the newly built instance of"
			eerror "nft. This probably means that there is a regression introduced by v${PV}."
			eerror "(To make the ebuild fail instead of warning, set NFTABLES_ABORT_ON_RELOAD_FAILURE=1.)"

			if [[ -n ${NFTABLES_ABORT_ON_RELOAD_FAILURE} ]] ; then
				die "Aborting because of failed nft reload!"
			fi
		fi
	fi
}

pkg_postinst() {
	local save_file
	save_file="${EROOT}"/var/lib/nftables/rules-save

	# In order for the nftables-restore systemd service to start
	# the save_file must exist.
	if [[ ! -f "${save_file}" ]]; then
		( umask 177; touch "${save_file}" )
	elif [[ $(( "$( stat --printf '%05a' "${save_file}" )" & 07177 )) -ne 0 ]]; then
		ewarn "Your system has dangerous permissions for ${save_file}"
		ewarn "It is probably affected by bug #691326."
		ewarn "You may need to fix the permissions of the file. To do so,"
		ewarn "you can run the command in the line below as root."
		ewarn "    'chmod 600 \"${save_file}\"'"
	fi

	if has_version 'sys-apps/systemd'; then
		elog "If you wish to enable the firewall rules on boot (on systemd) you"
		elog "will need to enable the nftables-restore service."
		elog "    'systemctl enable ${PN}-restore.service'"
		elog
		elog "If you are creating firewall rules before the next system restart"
		elog "the nftables-restore service must be manually started in order to"
		elog "save those rules on shutdown."
	fi

	if has_version 'sys-apps/openrc'; then
		elog "If you wish to enable the firewall rules on boot (on openrc) you"
		elog "will need to enable the nftables service."
		elog "    'rc-update add ${PN} default'"
		elog
		elog "If you are creating or updating the firewall rules and wish to save"
		elog "them to be loaded on the next restart, use the \"save\" functionality"
		elog "in the init script."
		elog "    'rc-service ${PN} save'"
	fi
}
