# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools linux-info pam tmpfiles

DESCRIPTION="Point-to-Point Protocol (PPP)"
HOMEPAGE="https://ppp.samba.org/"
SRC_URI="
	https://download.samba.org/pub/ppp/${P}.tar.gz
	https://raw.githubusercontent.com/ppp-project/ppp/${P}/contrib/pppgetpass/pppgetpass.8
"

LICENSE="BSD GPL-2"
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="activefilter atm gtk pam selinux systemd"

DEPEND="
	dev-libs/openssl:0=
	virtual/libcrypt:=
	activefilter? ( net-libs/libpcap )
	atm? ( net-dialup/linux-atm )
	gtk? ( x11-libs/gtk+:2 )
	pam? ( sys-libs/pam )
	systemd? ( sys-apps/systemd )
"
RDEPEND="
	${DEPEND}
	!<net-misc/netifrc-0.7.1-r2
	selinux? ( sec-policy/selinux-ppp )
"
BDEPEND="virtual/pkgconfig"
PDEPEND="net-dialup/ppp-scripts"

PATCHES=(
	"${FILESDIR}"/ppp-2.5.0-passwordfd-read-early.patch
	"${FILESDIR}"/ppp-2.5.0-pidfile.patch
	"${FILESDIR}"/ppp-2.5.0-radiusclient.conf-parsing.patch
	"${FILESDIR}"/ppp-2.5.0-openssl-pkgconfig.patch
	"${FILESDIR}"/ppp-2.5.0-pam-pkgconfig.patch
	"${FILESDIR}"/ppp-2.5.0-radius-mppe.patch
)

pkg_setup() {
	local CONFIG_CHECK="~PPP ~PPP_ASYNC ~PPP_SYNC_TTY"
	local ERROR_PPP="CONFIG_PPP:\t missing PPP support (REQUIRED)"
	local ERROR_PPP_ASYNC="CONFIG_PPP_ASYNC:\t missing asynchronous serial line discipline"
	ERROR_PPP_ASYNC+=" (optional, but highly recommended)"
	local WARNING_PPP_SYNC_TTY="CONFIG_PPP_SYNC_TTY:\t missing synchronous serial line discipline"
	WARNING_PPP_SYNC_TTY+=" (optional; used by 'sync' pppd option)"
	if use activefilter ; then
		CONFIG_CHECK+=" ~PPP_FILTER"
		local ERROR_PPP_FILTER="CONFIG_PPP_FILTER:\t missing PPP filtering support (REQUIRED)"
	fi
	CONFIG_CHECK+=" ~PPP_DEFLATE ~PPP_BSDCOMP ~PPP_MPPE"
	local ERROR_PPP_DEFLATE="CONFIG_PPP_DEFLATE:\t missing Deflate compression (optional, but highly recommended)"
	local ERROR_PPP_BSDCOMP="CONFIG_PPP_BSDCOMP:\t missing BSD-Compress compression (optional, but highly recommended)"
	local WARNING_PPP_MPPE="CONFIG_PPP_MPPE:\t missing MPPE encryption (optional, mostly used by PPTP links)"
	CONFIG_CHECK+=" ~PPPOE ~PACKET"
	local WARNING_PPPOE="CONFIG_PPPOE:\t missing PPPoE support (optional, needed by pppoe plugin)"
	local WARNING_PACKET="CONFIG_PACKET:\t missing AF_PACKET support (optional, used by pppoe plugin)"
	if use atm ; then
		CONFIG_CHECK+=" ~PPPOATM"
		local WARNING_PPPOATM="CONFIG_PPPOATM:\t missing PPPoA support (optional, needed by pppoatm plugin)"
	fi

	linux-info_pkg_setup
}

src_prepare() {
	default
	eautoreconf

	# Set the right paths in radiusclient.conf
	sed -e "s:/usr/local/etc:/etc:" \
		-e "s:/usr/local/sbin:/usr/sbin:" \
		-i pppd/plugins/radius/etc/radiusclient.conf || die
	# Set config dir to /etc/ppp/radius
	sed -i -e "s:/etc/radiusclient:/etc/ppp/radius:g" \
		pppd/plugins/radius/{*.8,*.c,*.h} \
		pppd/plugins/radius/etc/* || die
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
		--enable-multilink
	)
	econf "${args[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -type f -delete || die

	if use pam; then
		pamd_mimic_system ppp auth account session
	fi

	insinto /etc/modprobe.d
	newins "${FILESDIR}/modules.ppp" ppp.conf

	dosbin scripts/p{on,off,log}
	doman scripts/pon.1
	dosym pon.1 /usr/share/man/man1/poff.1
	dosym pon.1 /usr/share/man/man1/plog.1

	# Adding misc. specialized scripts to doc dir
	dodoc -r scripts

	if use gtk ; then
		dosbin contrib/pppgetpass/pppgetpass.{gtk,vt}
		newsbin contrib/pppgetpass/pppgetpass.sh pppgetpass
	else
		newsbin contrib/pppgetpass/pppgetpass.vt pppgetpass
	fi

	newtmpfiles "${FILESDIR}/pppd.tmpfiles" pppd.conf

	# Missing from upstream tarball
	# https://github.com/ppp-project/ppp/pull/412
	#doman contrib/pppgetpass/pppgetpass.8
	doman "${DISTDIR}/pppgetpass.8"

	insinto /etc/ppp/radius
	doins pppd/plugins/radius/etc/{dictionary*,issue,port-id-map,radiusclient.conf,realms,servers}
}

pkg_postinst() {
	tmpfiles_process pppd.conf
}
