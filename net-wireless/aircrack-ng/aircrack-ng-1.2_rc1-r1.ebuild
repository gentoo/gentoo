# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/aircrack-ng/aircrack-ng-1.2_rc1-r1.ebuild,v 1.1 2015/02/05 03:46:03 zerochaos Exp $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL=1

inherit toolchain-funcs distutils-r1 flag-o-matic

DESCRIPTION="WLAN tools for breaking 802.11 WEP/WPA keys"
HOMEPAGE="http://www.aircrack-ng.org"

if [[ ${PV} == "9999" ]] ; then
	inherit subversion
	ESVN_REPO_URI="http://svn.aircrack-ng.org/trunk"
	KEYWORDS=""
	S="${WORKDIR}/${PN}"
else
	MY_PV=${PV/_/-}
	SRC_URI="http://download.${PN}.org/${PN}-${MY_PV}.tar.gz"
	KEYWORDS="amd64 arm ppc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="GPL-2"
SLOT="0"

IUSE="+airdrop-ng +airgraph-ng kernel_linux kernel_FreeBSD +netlink +pcre +sqlite +unstable"

DEPEND="net-libs/libpcap
	dev-libs/openssl
	netlink? ( dev-libs/libnl:3 )
	pcre? ( dev-libs/libpcre )
	airdrop-ng? ( ${PYTHON_DEPS} )
	airgraph-ng? ( ${PYTHON_DEPS} )
	sqlite? ( >=dev-db/sqlite-3.4 )
	unstable? ( sys-libs/zlib )"
RDEPEND="${DEPEND}
	kernel_linux? (
		net-wireless/iw
		net-wireless/wireless-tools
		sys-apps/ethtool
		sys-apps/usbutils
		sys-apps/pciutils )
	sys-apps/hwids
	airdrop-ng? ( net-wireless/lorcon[python,${PYTHON_USEDEP}] )"

REQUIRED_USE="airdrop-ng? ( ${PYTHON_REQUIRED_USE} )
		airgraph-ng? ( ${PYTHON_REQUIRED_USE} )"

src_compile() {
	if [[ $($(tc-getCC) --version) == clang* ]] ; then
		die "Please use gcc, upstream bug http://trac.aircrack-ng.org/ticket/1144"
	fi

	if [[ ${PV} == "9999" ]] ; then
		liveflags=REVFLAGS=-D_REVISION="${ESVN_WC_REVISION}"
	fi

	emake \
	CC="$(tc-getCC)" \
	AR="$(tc-getAR)" \
	LD="$(tc-getLD)" \
	RANLIB="$(tc-getRANLIB)" \
	libnl=$(usex netlink true false) \
	pcre=$(usex pcre true false) \
	sqlite=$(usex sqlite true false) \
	unstable=$(usex unstable true false) \
	${liveflags}

	if use airgraph-ng; then
		cd "${S}/scripts/airgraph-ng"
		distutils-r1_src_compile
	fi
	if use airdrop-ng; then
		cd "${S}/scripts/airdrop-ng"
		distutils-r1_src_compile
	fi
}

src_test() {
	if [[ ${PV} == "9999" ]] ; then
		liveflags=REVFLAGS=-D_REVISION="${ESVN_WC_REVISION}"
	fi

	emake check \
		libnl=$(usex netlink true false) \
		pcre=$(usex pcre true false) \
		sqlite=$(usex sqlite true false) \
		unstable=$(usex unstable true false) \
		${liveflags}
}

src_install() {
	if [[ ${PV} == "9999" ]] ; then
		liveflags=REVFLAGS=-D_REVISION="${ESVN_WC_REVISION}"
	fi

	emake \
		prefix="${ED}/usr" \
		libnl=$(usex netlink true false) \
		pcre=$(usex pcre true false) \
		sqlite=$(usex sqlite true false) \
		unstable=$(usex unstable true false) \
		${liveflags} \
		install

	dodoc AUTHORS ChangeLog INSTALLING README

	if use airgraph-ng; then
		cd "${S}/scripts/airgraph-ng"
		distutils-r1_src_install
	fi
	if use airdrop-ng; then
		cd "${S}/scripts/airdrop-ng"
		distutils-r1_src_install
	fi

	#we don't need aircrack-ng's oui updater, we have our own
	rm "${ED}"/usr/sbin/airodump-ng-oui-update
}

pkg_postinst() {
	# Message is (c) FreeBSD
	# http://www.freebsd.org/cgi/cvsweb.cgi/ports/net-mgmt/aircrack-ng/files/pkg-message.in?rev=1.5
	if use kernel_FreeBSD ; then
		einfo "Contrary to Linux, it is not necessary to use airmon-ng to enable the monitor"
		einfo "mode of your wireless card.  So do not care about what the manpages say about"
		einfo "airmon-ng, airodump-ng sets monitor mode automatically."
		echo
		einfo "To return from monitor mode, issue the following command:"
		einfo "    ifconfig \${INTERFACE} -mediaopt monitor"
		einfo
		einfo "For aireplay-ng you need FreeBSD >= 7.0."
	fi
}
