# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit linux-info prefix systemd

DESCRIPTION='A high-level tool for configuring Netfilter'
HOMEPAGE="https://shorewall.org/"
LICENSE="GPL-2"
SLOT="0"
IUSE="doc +init +ipv4 ipv6 lite4 lite6 selinux"

MY_PV=${PV/_rc/-RC}
MY_PV=${MY_PV/_beta/-Beta}
MY_P=${PN}-${MY_PV}

MY_MAJOR_RELEASE_NUMBER=$(ver_cut 1-2)
MY_MAJORMINOR_RELEASE_NUMBER=$(ver_cut 1-3)

# shorewall
MY_PN_IPV4=Shorewall
MY_P_IPV4=${MY_PN_IPV4/#S/s}-${MY_PV}

# shorewall6
MY_PN_IPV6=Shorewall6
MY_P_IPV6=${MY_PN_IPV6/#S/s}-${MY_PV}

# shorewall-lite
MY_PN_LITE4=Shorewall-lite
MY_P_LITE4=${MY_PN_LITE4/#S/s}-${MY_PV}

# shorewall6-lite
MY_PN_LITE6=Shorewall6-lite
MY_P_LITE6=${MY_PN_LITE6/#S/s}-${MY_PV}

# shorewall-init
MY_PN_INIT=Shorewall-init
MY_P_INIT=${MY_PN_INIT/#S/s}-${MY_PV}

# shorewall-core
MY_PN_CORE=Shorewall-core
MY_P_CORE=${MY_PN_CORE/#S/s}-${MY_PV}

# shorewall-docs-html
MY_PN_DOCS=Shorewall-docs-html
MY_P_DOCS=${MY_PN_DOCS/#S/s}-${MY_PV}

# Upstream URL schema:
# Beta:    $MIRROR/pub/shorewall/development/4.6/shorewall-4.6.4-Beta2/shorewall-4.6.4-Beta2.tar.bz2
# RC:      $MIRROR/pub/shorewall/development/4.6/shorewall-4.6.4-RC1/shorewall-4.6.4-RC1.tar.bz2
# Release: $MIRROR/pub/shorewall/4.6/shorewall-4.6.3/shorewall-4.6.3.3.tar.bz2

MY_URL_PREFIX=
MY_URL_SUFFIX=
if [[ ${MY_PV} = *-Beta* ]] || [[ ${MY_PV} = *-RC* ]]; then
	MY_URL_PREFIX='development/'

	if [[ ${MY_PV} = *-Beta* ]] ; then
		MY_URL_SUFFIX="-Beta${MY_PV##*-Beta}"
	elif [[ ${MY_PV} = *-RC* ]] ; then
		MY_URL_SUFFIX="-RC${MY_PV##*-RC}"
	fi

	# Cleaning up temporary variables
	unset _tmp_last_index
	unset _tmp_suffix
else
	KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

SRC_URI="
	https://shorewall.org/pub/shorewall/${MY_URL_PREFIX}${MY_MAJOR_RELEASE_NUMBER}/shorewall-${MY_MAJORMINOR_RELEASE_NUMBER}${MY_URL_SUFFIX}/shorewall-core-${MY_PV}.tar.bz2
	ipv4? ( https://shorewall.org/pub/shorewall/${MY_URL_PREFIX}${MY_MAJOR_RELEASE_NUMBER}/shorewall-${MY_MAJORMINOR_RELEASE_NUMBER}${MY_URL_SUFFIX}/shorewall-${MY_PV}.tar.bz2 )
	ipv6? ( https://shorewall.org/pub/shorewall/${MY_URL_PREFIX}${MY_MAJOR_RELEASE_NUMBER}/shorewall-${MY_MAJORMINOR_RELEASE_NUMBER}${MY_URL_SUFFIX}/shorewall6-${MY_PV}.tar.bz2 )
	lite4? ( https://shorewall.org/pub/shorewall/${MY_URL_PREFIX}${MY_MAJOR_RELEASE_NUMBER}/shorewall-${MY_MAJORMINOR_RELEASE_NUMBER}${MY_URL_SUFFIX}/shorewall-lite-${MY_PV}.tar.bz2 )
	lite6? ( https://shorewall.org/pub/shorewall/${MY_URL_PREFIX}${MY_MAJOR_RELEASE_NUMBER}/shorewall-${MY_MAJORMINOR_RELEASE_NUMBER}${MY_URL_SUFFIX}/shorewall6-lite-${MY_PV}.tar.bz2 )
	init? ( https://shorewall.org/pub/shorewall/${MY_URL_PREFIX}${MY_MAJOR_RELEASE_NUMBER}/shorewall-${MY_MAJORMINOR_RELEASE_NUMBER}${MY_URL_SUFFIX}/shorewall-init-${MY_PV}.tar.bz2 )
	doc? ( https://shorewall.org/pub/shorewall/${MY_URL_PREFIX}${MY_MAJOR_RELEASE_NUMBER}/shorewall-${MY_MAJORMINOR_RELEASE_NUMBER}${MY_URL_SUFFIX}/${MY_P_DOCS}.tar.bz2 )
"

# - Shorewall6 requires Shorewall
# - Installing Shorewall-init or just the documentation doesn't make any sense,
#   that's why we force the user to select at least one "real" Shorewall product
#
# See https://shorewall.org/download.htm#Which
REQUIRED_USE="
	ipv6? ( ipv4 )
	|| ( ipv4 lite4 lite6 )
"

# No build dependencies! Just plain shell scripts...
DEPEND=""

RDEPEND="
	>=net-firewall/iptables-1.4.20
	>=sys-apps/iproute2-3.8.0[-minimal]
	>=sys-devel/bc-1.06.95
	ipv4? (
		>=dev-lang/perl-5.16
		virtual/perl-Digest-SHA
	)
	ipv6? (
		>=dev-perl/Socket6-0.230.0
		>=net-firewall/iptables-1.4.20[ipv6]
		>=sys-apps/iproute2-3.8.0[ipv6]
	)
	lite6? (
		>=net-firewall/iptables-1.4.20[ipv6]
		>=sys-apps/iproute2-3.8.0[ipv6]
	)
	init? ( >=sys-apps/coreutils-8.20 )
	selinux? ( >=sec-policy/selinux-shorewall-2.20161023-r3 )
	!net-firewall/shorewall-core
	!net-firewall/shorewall6
	!net-firewall/shorewall-lite
	!net-firewall/shorewall6-lite
	!net-firewall/shorewall-init
	!<sys-apps/systemd-214
"

S=${WORKDIR}

pkg_pretend() {
	local CONFIG_CHECK="~NF_CONNTRACK"

	local WARNING_CONNTRACK="Without NF_CONNTRACK support, you will be unable"
	local WARNING_CONNTRACK+=" to run any shorewall-based firewall on the local system."

	# kernel >=4.19 has unified NF_CONNTRACK module, bug 671176
	if kernel_is -lt 4 19; then
		if use ipv4 || use lite4; then
			CONFIG_CHECK="${CONFIG_CHECK} ~NF_CONNTRACK_IPV4"

			local WARNING_CONNTRACK_IPV4="Without NF_CONNTRACK_IPV4 support, you will"
			local WARNING_CONNTRACK_IPV4+=" be unable to run any shorewall-based IPv4 firewall on the local system."
		fi

		if use ipv6 || use lite6; then
			CONFIG_CHECK="${CONFIG_CHECK} ~NF_CONNTRACK_IPV6"

			local WARNING_CONNTRACK_IPV6="Without NF_CONNTRACK_IPV6 support, you will"
			local WARNING_CONNTRACK_IPV6+=" be unable to run any shorewall-based IPv6 firewall on the local system."
		fi
	fi

	check_extra_config
}

pkg_setup() {
	if [[ -n "${DIGEST}" ]]; then
		einfo "Unsetting environment variable \"DIGEST\" to prevent conflicts with package's \"install.sh\" script ..."
		unset DIGEST
	fi
}

src_prepare() {
	# We are moving each unpacked source from MY_P_* to MY_PN_*.
	# This allows us to use patches from upstream and keeps epatch_user working

	einfo "Preparing shorewallrc ..."
	cp "${FILESDIR}"/shorewallrc-r3 "${S}"/shorewallrc.gentoo || die "Copying shorewallrc failed"
	eprefixify "${S}"/shorewallrc.gentoo
	sed -i \
		-e "s|SERVICEDIR=tbs|SERVICEDIR=$(systemd_get_systemunitdir)|" \
		"${S}"/shorewallrc.gentoo || die "Failed to update shorewallrc"

	# shorewall-core
	mv "${S}"/${MY_P_CORE} "${S}"/${MY_PN_CORE} || die "Failed to move '${S}/${MY_P_CORE}' to '${S}/${MY_PN_CORE}'"
	ebegin "Applying Gentoo-specific changes to ${MY_P_CORE} ..."
	ln -s ../shorewallrc.gentoo ${MY_PN_CORE}/shorewallrc.gentoo || die "Failed to symlink shorewallrc.gentoo"
	eend 0

	pushd "${S}"/${MY_PN_CORE} &>/dev/null || die
	eapply "${FILESDIR}"/shorewall-core-5.2.1-no-gzipped-manpages.patch
	popd &>/dev/null || die

	# shorewall
	if use ipv4; then
		mv "${S}"/${MY_P_IPV4} "${S}"/${MY_PN_IPV4} || die "Failed to move '${S}/${MY_P_IPV4}' to '${S}/${MY_PN_IPV4}'"
		ebegin "Applying Gentoo-specific changes to ${MY_P_IPV4}"
		ln -s ../shorewallrc.gentoo ${MY_PN_IPV4}/shorewallrc.gentoo || die "Failed to symlink shorewallrc.gentoo"
		cp "${FILESDIR}"/shorewall.confd-r1 "${S}"/${MY_PN_IPV4}/default.gentoo || die "Copying shorewall.confd-r1 failed"
		cp "${FILESDIR}"/shorewall.initd-r3 "${S}"/${MY_PN_IPV4}/init.gentoo.sh || die "Copying shorewall.initd-r2 failed"
		cp "${FILESDIR}"/shorewall.systemd "${S}"/${MY_PN_IPV4}/gentoo.service || die "Copying shorewall.systemd failed"
		eend 0

		pushd "${S}"/${MY_PN_IPV4} &>/dev/null || die
		eapply "${FILESDIR}"/shorewall-5.2.1-no-gzipped-manpages.patch
		popd &>/dev/null || die
	fi

	# shorewall6
	if use ipv6; then
		mv "${S}"/${MY_P_IPV6} "${S}"/${MY_PN_IPV6} || die "Failed to move '${S}/${MY_P_IPV6}' to '${S}/${MY_PN_IPV6}'"
		ebegin "Applying Gentoo-specific changes to ${MY_P_IPV6}"
		ln -s ../shorewallrc.gentoo ${MY_PN_IPV6}/shorewallrc.gentoo || die "Failed to symlink shorewallrc.gentoo"
		cp "${FILESDIR}"/shorewall.confd-r1 "${S}"/${MY_PN_IPV6}/default.gentoo || die "Copying shorewall.confd-r1 failed"
		cp "${FILESDIR}"/shorewall.initd-r3 "${S}"/${MY_PN_IPV6}/init.gentoo.sh || die "Copying shorewall.initd-r2 failed"
		cp "${FILESDIR}"/shorewall6.systemd "${S}"/${MY_PN_IPV6}/gentoo.service || die "Copying shorewall6.systemd failed"
		eend 0

		pushd "${S}"/${MY_PN_IPV6} &>/dev/null || die
		eapply "${FILESDIR}"/shorewall-5.2.1-no-gzipped-manpages.patch
		popd &>/dev/null || die
	fi

	# shorewall-lite
	if use lite4; then
		mv "${S}"/${MY_P_LITE4} "${S}"/${MY_PN_LITE4} || die "Failed to move '${S}/${MY_P_LITE4}' to '${S}/${MY_PN_LITE4}'"
		ebegin "Applying Gentoo-specific changes to ${MY_P_LITE4}"
		ln -s ../shorewallrc.gentoo ${MY_PN_LITE4}/shorewallrc.gentoo || die "Failed to symlink shorewallrc.gentoo"
		cp "${FILESDIR}"/shorewall-lite.confd-r1 "${S}"/${MY_PN_LITE4}/default.gentoo || die "Copying shorewall-lite.confd-r1 failed"
		cp "${FILESDIR}"/shorewall-lite.initd-r3 "${S}"/${MY_PN_LITE4}/init.gentoo.sh || die "Copying shorewall-lite.initd-r2 failed"
		cp "${FILESDIR}"/shorewall-lite.systemd "${S}"/${MY_PN_LITE4}/gentoo.service || die "Copying shorewall-lite.systemd failed"
		eend 0

		pushd "${S}"/${MY_PN_LITE4} &>/dev/null || die
		eapply "${FILESDIR}"/shorewall-lite-5.2.1-no-gzipped-manpages.patch
		popd &>/dev/null || die
	fi

	# shorewall6-lite
	if use lite6; then
		mv "${S}"/${MY_P_LITE6} "${S}"/${MY_PN_LITE6} || die "Failed to move '${S}/${MY_P_LITE6}' to '${S}/${MY_PN_LITE6}'"
		ebegin "Applying Gentoo-specific changes to ${MY_P_LITE6}"
		ln -s ../shorewallrc.gentoo ${MY_PN_LITE6}/shorewallrc.gentoo || die "Failed to symlink shorewallrc.gentoo"
		cp "${FILESDIR}"/shorewall-lite.confd-r1 "${S}"/${MY_PN_LITE6}/default.gentoo || die "Copying shorewall-lite.confd-r1 failed"
		cp "${FILESDIR}"/shorewall-lite.initd-r3 "${S}"/${MY_PN_LITE6}/init.gentoo.sh || die "Copying shorewall-lite.initd-r2 failed"
		cp "${FILESDIR}"/shorewall6-lite.systemd "${S}"/${MY_PN_LITE6}/gentoo.service || die "Copying shorewall6-lite.systemd failed"
		eend 0

		pushd "${S}"/${MY_PN_LITE6} &>/dev/null || die
		eapply "${FILESDIR}"/shorewall-lite-5.2.1-no-gzipped-manpages.patch
		popd &>/dev/null || die
	fi

	# shorewall-init
	if use init; then
		mv "${S}"/${MY_P_INIT} "${S}"/${MY_PN_INIT} || die "Failed to move '${S}/${MY_P_INIT}' to '${S}/${MY_PN_INIT}'"
		ebegin "Applying Gentoo-specific changes to ${MY_P_INIT}"
		ln -s ../shorewallrc.gentoo ${MY_PN_INIT}/shorewallrc.gentoo || die "Failed to symlink shorewallrc.gentoo"
		cp "${FILESDIR}"/shorewall-init.confd "${S}"/${MY_PN_INIT}/default.gentoo || die "Copying shorewall-init.confd failed"
		cp "${FILESDIR}"/shorewall-init.initd "${S}"/${MY_PN_INIT}/init.gentoo.sh || die "Copying shorewall-init.initd failed"
		cp "${FILESDIR}"/shorewall-init.systemd "${S}"/${MY_PN_INIT}/gentoo.service || die "Copying shorewall-init.systemd failed"
		cp "${FILESDIR}"/shorewall-init.readme "${S}"/${MY_PN_INIT}/shorewall-init.README.Gentoo.txt || die "Copying shorewall-init.systemd failed"
		eend 0

		eprefixify "${S}"/${MY_PN_INIT}/init.gentoo.sh

		pushd "${S}"/${MY_PN_INIT} &>/dev/null || die
		eapply -p2 "${FILESDIR}"/shorewall-init-01_remove-ipset-functionality-r2.patch
		popd &>/dev/null || die
	fi

	# shorewall-docs-html
	if use doc; then
		mv "${S}"/${MY_P_DOCS} "${S}"/${MY_PN_DOCS} || die "Failed to move '${S}/${MY_P_DOCS}' to '${S}/${MY_PN_DOCS}'"
	fi

	eapply_user
}

src_configure() {
	:;
}

src_compile() {
	:;
}

src_install() {
	# shorewall-core
	einfo "Installing ${MY_P_CORE} ..."
	DESTDIR="${ED}" ${MY_PN_CORE}/install.sh shorewallrc.gentoo || die "${MY_PN_CORE}/install.sh failed"
	dodoc "${S}"/${MY_PN_CORE}/changelog.txt "${S}"/${MY_PN_CORE}/releasenotes.txt

	# shorewall
	if use ipv4; then
		einfo "Installing ${MY_P_IPV4} ..."
		DESTDIR="${ED}" ${MY_PN_IPV4}/install.sh shorewallrc.gentoo || die "${MY_PN_IPV4}/install.sh failed"
		keepdir /var/lib/shorewall

		if use doc; then
			dodoc -r "${S}"/${MY_PN_IPV4}/Samples
		fi
	fi

	# shorewall6
	if use ipv6; then
		einfo "Installing ${MY_P_IPV6} ..."
		DESTDIR="${ED}" ${MY_PN_IPV6}/install.sh shorewallrc.gentoo || die "${MY_PN_IPV6}/install.sh failed"
		keepdir /var/lib/shorewall6

		if use doc; then
			dodoc -r "${S}"/${MY_PN_IPV6}/Samples6
		fi
	fi

	# shorewall-lite
	if use lite4; then
		einfo "Installing ${MY_P_LITE4} ..."
		DESTDIR="${ED}" ${MY_PN_LITE4}/install.sh shorewallrc.gentoo || die "${MY_PN_LITE4}/install.sh failed"
		keepdir /var/lib/shorewall-lite
	fi

	# shorewall6-lite
	if use lite6; then
		einfo "Installing ${MY_P_LITE6} ..."
		DESTDIR="${ED}" ${MY_PN_LITE6}/install.sh shorewallrc.gentoo || die "${MY_PN_LITE6}/install.sh failed"
		keepdir /var/lib/shorewall6-lite
	fi

	# shorewall-init
	if use init; then
		einfo "Installing ${MY_P_INIT} ..."
		DESTDIR="${ED}" ${MY_PN_INIT}/install.sh shorewallrc.gentoo || die "${MY_PN_INIT}/install.sh failed"
		dodoc "${S}"/${MY_PN_INIT}/shorewall-init.README.Gentoo.txt

		if [[ -f "${ED}/etc/logrotate.d/shorewall-init" ]]; then
			# On Gentoo, shorewall-init will not create shorewall-ifupdown.log,
			# so we don't need a logrotate configuration file for shorewall-init
			einfo "Removing unused \"${ED}/etc/logrotate.d/shorewall-init\" ..."
			rm -rf "${ED}"/etc/logrotate.d/shorewall-init || die "Removing \"${ED}/etc/logrotate.d/shorewall-init\" failed"
		fi

		if [[ -d "${ED}/etc/NetworkManager" ]]; then
			# On Gentoo, we don't support NetworkManager
			# so we don't need this folder at all
			einfo "Removing unused \"${ED}/etc/NetworkManager\" ..."
			rm -rf "${ED}"/etc/NetworkManager || die "Removing \"${ED}/etc/NetworkManager\" failed"
		fi

		if [[ -f "${ED}/usr/share/shorewall-init/ifupdown" ]]; then
			# This script isn't supported on Gentoo
			rm -rf "${ED}"/usr/share/shorewall-init/ifupdown || die "Removing \"${ED}/usr/share/shorewall-init/ifupdown\" failed"
		fi
	fi

	if use doc; then
		einfo "Installing ${MY_P_DOCS} ..."
		docinto html && dodoc -r "${S}"/${MY_PN_DOCS}/*
	fi
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation

		# Show first steps for shorewall/shorewall6
		local _PRODUCTS=""
		if use ipv4; then
			_PRODUCTS="shorewall"

			if use ipv6; then
				_PRODUCTS="${_PRODUCTS}/shorewall6"
			fi
		fi

		if [[ -n "${_PRODUCTS}" ]]; then
			elog "Before you can use ${_PRODUCTS}, you need to edit its configuration in:"
			elog ""
			elog "  /etc/shorewall/shorewall.conf"

			if use ipv6; then
				elog "  /etc/shorewall6/shorewall6.conf"
			fi

			elog ""
			elog "To activate your shorewall-based firewall on system start, please add ${_PRODUCTS} to your default runlevel:"
			elog ""
			elog "  # rc-update add shorewall default"

			if use ipv6; then
				elog "  # rc-update add shorewall6 default"
			fi
		fi

		# Show first steps for shorewall-lite/shorewall6-lite
		_PRODUCTS=""
		if use lite4; then
			_PRODUCTS="shorewall-lite"
		fi

		if use lite6; then
			if [[ -z "${_PRODUCTS}" ]]; then
				_PRODUCTS="shorewall6-lite"
			else
				_PRODUCTS="${_PRODUCTS}/shorewall6-lite"
			fi
		fi

		if [[ -n "${_PRODUCTS}" ]]; then
			if use ipv4; then
				elog ""
			fi

			elog "Before you can use ${_PRODUCTS}, you need to provide a configuration, which you can"
			elog "create using ${CATEGORY}/shorewall (with \"ipv4\" and or \"ipv6\" USE flag)."
			elog ""
			elog "To read more about ${_PRODUCTS}, please visit"
			elog "  https://shorewall.org/CompiledPrograms.html"
			elog ""
			elog "To activate your shorewall-lite-based firewall on system start, please add ${PRODUCTS} to your default runlevel:"
			elog ""

			if use lite4; then
				elog "  # rc-update add shorewall-lite default"
			fi

			if use lite6; then
				elog "  # rc-update add shorewall6-lite default"
			fi
		fi

		if use init; then
			elog ""
			elog "To secure your system on boot, please add shorewall-init to your boot runlevel:"
			elog ""
			elog "  # rc-update add shorewall-init boot"
			elog ""
			elog "and review \$PRODUCTS in"
			elog ""
			elog "  /etc/conf.d/shorewall-init"
		fi

	fi

	local v
	for v in ${REPLACING_VERSIONS}; do
		if ! version_is_at_least ${MY_MAJOR_RELEASE_NUMBER} ${v}; then
			# This is an upgrade

			elog "You are upgrading from a previous major version. It is highly recommended that you read"
			elog ""
			elog "  - /usr/share/doc/shorewall*/releasenotes.tx*"
			elog "  - https://shorewall.org/Shorewall-5.html#idm214"

			if use ipv4; then
				elog ""
				elog "You can auto-migrate your configuration using"
				elog ""
				elog "  # shorewall update -A"

				if use ipv6; then
					elog "  # shorewall6 update -A"
				fi

				elog ""
				elog "*after* you have merged the changed files using one of the configuration"
				elog "files update tools of your choice (dispatch-conf, etc-update...)."

				elog ""
				elog "But if you are not familiar with the \"shorewall[6] update\" command,"
				elog "please read the shorewall[6] man page first."
			fi

			# Show this elog only once
			break
		fi
	done

	if ! use init; then
		elog ""
		elog "Consider emerging ${CATEGORY}/${PN} with USE flag \"init\" to secure your system on boot"
		elog "before your shorewall-based firewall is ready to start."
		elog ""
		elog "To read more about shorewall-init, please visit"
		elog "  https://shorewall.org/Shorewall-init.html"
	fi

	if ! has_version "net-firewall/conntrack-tools"; then
		elog ""
		elog "Your Shorewall firewall can utilize \"conntrack\" from the \"net-firewall/conntrack-tools\""
		elog "package. if you want to use this feature, you need to install \"net-firewall/conntrack-tools\"!"
	fi

	if ! has_version "dev-perl/Devel-NYTProf"; then
		elog ""
		elog "If you want to profile your Shorewall firewall you need to install \"dev-perl/Devel-NYTProf\"!"
	fi
}
