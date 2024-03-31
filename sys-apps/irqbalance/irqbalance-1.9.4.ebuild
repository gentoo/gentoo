# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson linux-info optfeature systemd udev

DESCRIPTION="Distribute hardware interrupts across processors on a multiprocessor system"
HOMEPAGE="https://github.com/Irqbalance/irqbalance"
SRC_URI="https://github.com/Irqbalance/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${P}/contrib

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="caps +numa systemd selinux thermal tui"
# Hangs
RESTRICT="test"

DEPEND="
	dev-libs/glib:2
	caps? ( sys-libs/libcap-ng )
	numa? ( sys-process/numactl )
	systemd? ( sys-apps/systemd:= )
	thermal? ( dev-libs/libnl:3 )
	tui? ( sys-libs/ncurses:=[unicode(+)] )
"
BDEPEND="
	virtual/pkgconfig
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-irqbalance )
"

pkg_setup() {
	CONFIG_CHECK="~PCI_MSI"
	linux-info_pkg_setup
}

src_prepare() {
	default

	# Follow systemd policies
	# https://wiki.gentoo.org/wiki/Project:Systemd/Ebuild_policy
	sed \
		-e 's/ $IRQBALANCE_ARGS//' \
		-e '/EnvironmentFile/d' \
		-i "${WORKDIR}"/${P}/misc/irqbalance.service || die
}

src_configure() {
	local emesonargs=(
		$(meson_feature caps capng)
		$(meson_feature numa)
		$(meson_feature systemd)
		$(meson_feature thermal)
		$(meson_feature tui ui)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	newinitd "${FILESDIR}"/irqbalance.init.4 irqbalance
	newconfd "${FILESDIR}"/irqbalance.confd-2 irqbalance
	systemd_dounit "${WORKDIR}"/${P}/misc/irqbalance.service
	udev_dorules "${WORKDIR}"/${P}/misc/90-irqbalance.rules
}

pkg_postrm() {
	udev_reload
}

pkg_postinst() {
	udev_reload
	optfeature "thermal events support (requires USE=thermal)" sys-power/thermald
}
