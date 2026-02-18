# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd toolchain-funcs tmpfiles

DESCRIPTION="A modern version of the Layer 2 Tunneling Protocol (L2TP) daemon"
HOMEPAGE="https://github.com/xelerance/xl2tpd"
SRC_URI="
	https://github.com/xelerance/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://downloads.uls.co.za/patches/${PN}/${PN}-1.3.18-r2-Pass-remotenumber-to-pppd.patch
	poll? ( https://downloads.uls.co.za/patches/${PN}/${PN}-1.3.20-ditch-select-use-poll.patch )
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~x86"
IUSE="+kernel poll"

DEPEND="
	net-libs/libpcap
	>=sys-kernel/linux-headers-2.6"

RDEPEND="
	${DEPEND}
	net-dialup/ppp"

DOCS=( CREDITS README.md BUGS CHANGES TODO doc/README.patents )

PATCHES=(
	"${DISTDIR}/xl2tpd-1.3.18-r2-Pass-remotenumber-to-pppd.patch"
)

src_prepare() {
	default
	use poll && epatch "${DISTDIR}/xl2tpd-1.3.20-ditch-select-use-poll.patch"
	sed -e 's:/var/run/:/run/:' -i \
		file.h \
		l2tp.h \
		xl2tpd-control.c \
		doc/l2tp-secrets.5 \
		doc/xl2tpd.8 \
		doc/xl2tpd.conf.5 \
		|| die "Error updating /var/run to /run"
}

src_compile() {
	tc-export CC
	local OSFLAGS="-DLINUX"
	use kernel && OSFLAGS+=" -DUSE_KERNEL"
	emake OSFLAGS="${OSFLAGS}"
}

src_install() {
	emake PREFIX=/usr DESTDIR="${D}" install

	newinitd "${FILESDIR}"/xl2tpd-init-r1 xl2tpd

	systemd_dounit "${FILESDIR}"/xl2tpd.service
	dotmpfiles "${FILESDIR}"/xl2tpd.conf

	einstalldocs

	insinto /etc/xl2tpd
	newins doc/l2tpd.conf.sample xl2tpd.conf
	insopts -m 0600
	newins doc/l2tp-secrets.sample l2tp-secrets
}

pkg_postinst() {
	tmpfiles_process xl2tpd.conf
}
