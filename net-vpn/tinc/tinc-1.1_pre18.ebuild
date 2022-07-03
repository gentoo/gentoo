# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=${PV/_/}
MY_P=${PN}-${MY_PV}

inherit autotools systemd

DESCRIPTION="tinc is an easy to configure VPN implementation"
HOMEPAGE="https://www.tinc-vpn.org/"

SRC_URI="https://www.tinc-vpn.org/packages/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="+lzo +ncurses +readline +ssl uml vde upnp +zlib"

DEPEND="
	ssl? (
		dev-libs/openssl:0=
	)
	lzo? ( dev-libs/lzo:2 )
	ncurses? ( sys-libs/ncurses:= )
	readline? ( sys-libs/readline:= )
	upnp? ( net-libs/miniupnpc )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}
	vde? ( net-misc/vde )"
S="${WORKDIR}/${MY_P}"

PATCHES+=(
	"${FILESDIR}"/tinc-1.1_pre16-r1-fix-paths.patch #560528
	"${FILESDIR}"/${PN}-1.1-tinfo.patch #621868
)

src_prepare() {
	default
	eautoreconf

	# Fix the static (failing UNKNOWN) version in the autoconf
	# NOTE: When updating the ebuild, make sure to check that this
	# line number hasn't changed in the upstream sources.
	sed -i "6d" configure.ac
	sed -i "6iAC_INIT([tinc], ${PVR})" configure.ac
}

src_configure() {
	econf \
		--enable-jumbograms \
		--enable-legacy-protocol \
		--disable-tunemu  \
		--with-systemd="$(systemd_get_systemunitdir)" \
		$(use_enable lzo) \
		$(use_enable ncurses curses) \
		$(use_enable readline) \
		$(use_enable uml) \
		$(use_enable vde) \
		$(use_enable zlib) \
		$(use_enable upnp miniupnpc) \
		$(use_with ssl openssl)
		#--without-libgcrypt \
}

src_install() {
	emake DESTDIR="${D}" install
	dodir /etc/tinc
	dodoc AUTHORS NEWS README THANKS
	doconfd "${FILESDIR}"/tinc.networks
	newconfd "${FILESDIR}"/tincd.conf tincd
	newinitd "${FILESDIR}"/tincd-r2 tincd
}

pkg_postinst() {
	elog "This package requires the tun/tap kernel device."
	elog "Look at http://www.tinc-vpn.org/ for how to configure tinc"
}
