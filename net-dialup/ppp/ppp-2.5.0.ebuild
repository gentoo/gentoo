# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
AUTOTOOLS_AUTO_DEPEND=no

inherit autotools linux-info pam

PATCH_TARBALL_NAME="${PN}-2.4.9-patches-03"
DESCRIPTION="Point-to-Point Protocol (PPP)"
HOMEPAGE="https://ppp.samba.org/"
SRC_URI="https://download.samba.org/pub/ppp/${P}.tar.gz
	https://github.com/ppp-project/ppp/blob/${P}/contrib/pppgetpass/pppgetpass.8
	dhcp? (
		http://www.netservers.net.uk/gpl/ppp-dhcpc.tgz
		https://dev.gentoo.org/~floppym/dist/${P}-dhcp-patches.tar.gz
	)"
#https://dev.gentoo.org/~polynomial-c/${PATCH_TARBALL_NAME}.tar.xz

LICENSE="BSD GPL-2"
SLOT="0/${PV}"
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="activefilter atm dhcp gtk pam systemd"

DEPEND="
	dev-libs/openssl:0=
	virtual/libcrypt:=
	activefilter? ( net-libs/libpcap )
	atm? ( net-dialup/linux-atm )
	gtk? ( x11-libs/gtk+:2 )
	pam? ( sys-libs/pam )
	systemd? ( sys-apps/systemd )
"
RDEPEND="${DEPEND}
	!<net-misc/netifrc-0.7.1-r2"
BDEPEND="virtual/pkgconfig
	dhcp? ( ${AUTOTOOLS_DEPEND} )"
PDEPEND="net-dialup/ppp-scripts"

src_prepare() {
	if use dhcp; then
		eapply "${FILESDIR}/ppp-2.5.0-add-dhcp-plugin.patch"
		cd "${WORKDIR}/dhcp" || die
		eapply "${WORKDIR}/ppp-2.5.0-dhcp-patches"
		cd "${S}" || die
		mv "${WORKDIR}/dhcp" "${S}/pppd/plugins/dhcp" || die
	fi
	default
	if use dhcp; then
		eautoreconf
	fi
}

src_configure() {
	local args=(
		--localstatedir="${EPREFIX}"/var
		--runstatedir="${EPREFIX}"/run
		$(use_enable systemd)
		$(use_with atm)
		$(use_with pam)
		$(use_with activefilter pcap)
		$(use_with gtk)
		--enable-cbcp
	)
	econf "${args[@]}"
}

src_compile() {
	default
}

src_install() {
	default

	find "${ED}" -name '*.la' -type f -delete || die

	if use pam; then
		pamd_mimic_system ppp auth account session
	fi

	insinto /etc/modprobe.d
	newins "${FILESDIR}/modules.ppp" ppp.conf

	dobin scripts/p{on,off,log}
	doman scripts/pon.1

	# Adding misc. specialized scripts to doc dir
	dodoc -r scripts

	if use gtk ; then
		dosbin contrib/pppgetpass/pppgetpass.{gtk,vt}
		newsbin contrib/pppgetpass/pppgetpass.sh pppgetpass
	else
		newsbin contrib/pppgetpass/pppgetpass.vt pppgetpass
	fi
	# Missing from upstream tarball
	# https://github.com/ppp-project/ppp/pull/412
	#doman contrib/pppgetpass/pppgetpass.8
	doman "${DISTDIR}/pppgetpass.8"
}

pkg_postinst() {
	if linux-info_get_any_version && linux_config_src_exists ; then
		echo
		ewarn "If the following test report contains a missing kernel configuration option that you need,"
		ewarn "you should reconfigure and rebuild your kernel before running pppd."
		CONFIG_CHECK="~PPP ~PPP_ASYNC ~PPP_SYNC_TTY"
		local ERROR_PPP="CONFIG_PPP:\t missing PPP support (REQUIRED)"
		local ERROR_PPP_ASYNC="CONFIG_PPP_ASYNC:\t missing asynchronous serial line discipline (optional, but highly recommended)"
		local WARNING_PPP_SYNC_TTY="CONFIG_PPP_SYNC_TTY:\t missing synchronous serial line discipline (optional; used by 'sync' pppd option)"
		if use activefilter ; then
			CONFIG_CHECK="${CONFIG_CHECK} ~PPP_FILTER"
			local ERROR_PPP_FILTER="CONFIG_PPP_FILTER:\t missing PPP filtering support (REQUIRED)"
		fi
		CONFIG_CHECK="${CONFIG_CHECK} ~PPP_DEFLATE ~PPP_BSDCOMP ~PPP_MPPE"
		local ERROR_PPP_DEFLATE="CONFIG_PPP_DEFLATE:\t missing Deflate compression (optional, but highly recommended)"
		local ERROR_PPP_BSDCOMP="CONFIG_PPP_BSDCOMP:\t missing BSD-Compress compression (optional, but highly recommended)"
		local WARNING_PPP_MPPE="CONFIG_PPP_MPPE:\t missing MPPE encryption (optional, mostly used by PPTP links)"
		CONFIG_CHECK="${CONFIG_CHECK} ~PPPOE ~PACKET"
		local WARNING_PPPOE="CONFIG_PPPOE:\t missing PPPoE support (optional, needed by pppoe plugin)"
		local WARNING_PACKET="CONFIG_PACKET:\t missing AF_PACKET support (optional, used by pppoe plugin)"
		if use atm ; then
			CONFIG_CHECK="${CONFIG_CHECK} ~PPPOATM"
			local WARNING_PPPOATM="CONFIG_PPPOATM:\t missing PPPoA support (optional, needed by pppoatm plugin)"
		fi
		check_extra_config
	fi

	echo
	elog "pon, poff and plog scripts have been supplied for experienced users."
	elog "Users needing particular scripts (ssh,rsh,etc.) should check out the"
	elog "/usr/share/doc/${PF}/scripts directory."
}
