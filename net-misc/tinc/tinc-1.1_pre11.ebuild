# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

MY_PV=${PV/_/}
MY_P=${PN}-${MY_PV}

PYTHON_COMPAT=( python2_7 )
inherit eutils systemd python-any-r1

DESCRIPTION="tinc is an easy to configure VPN implementation"
HOMEPAGE="http://www.tinc-vpn.org/"
SRC_URI="http://www.tinc-vpn.org/packages/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="+lzo +ncurses +openssl gcrypt gui +readline uml vde +zlib"

DEPEND="dev-libs/openssl:=
	lzo? ( dev-libs/lzo:2 )
	ncurses? ( sys-libs/ncurses )
	readline? ( sys-libs/readline:= )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}
	vde? ( net-misc/vde )
	${PYTHON_DEPS}
	gui? ( $(python_gen_any_dep '
	dev-python/wxpython[${PYTHON_USEDEP}]
	') )"

REQUIRED_USE="^^ ( openssl gcrypt )"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf \
		--enable-jumbograms \
		--disable-tunemu  \
		--with-windows2000 \
		--disable-silent-rules \
		$(use_enable lzo) \
		$(use_enable ncurses curses) \
		$(use_enable readline) \
		$(use_enable uml) \
		$(use_enable vde) \
		$(use_enable zlib) \
		$(use_with openssl) \
#		$(use_with gcrypt libgcrypt), upstream not ready
}

src_install() {
	emake DESTDIR="${D}" install
	dodir /etc/tinc
	dodoc AUTHORS NEWS README THANKS
	doconfd "${FILESDIR}"/tinc.networks
	newconfd "${FILESDIR}"/tincd.conf tincd
	newinitd "${FILESDIR}"/tincd-r1 tincd
	systemd_newunit "${FILESDIR}"/tincd_at.service "tincd@.service"

	if use gui; then
		python_fix_shebang "${ED}"/usr/bin/tinc-gui
	else
		rm -f "${ED}"/usr/bin/tinc-gui || die
	fi
}

pkg_postinst() {
	elog "This package requires the tun/tap kernel device."
	elog "Look at http://www.tinc-vpn.org/ for how to configure tinc"
}
