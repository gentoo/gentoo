# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools udev systemd linux-info optfeature

DESCRIPTION="Distribute hardware interrupts across processors on a multiprocessor system"
HOMEPAGE="https://github.com/Irqbalance/irqbalance"
SRC_URI="https://github.com/Irqbalance/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv x86"
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

PATCHES=(
	"${FILESDIR}"/${P}-systemd-journal-noise.patch
)

pkg_setup() {
	CONFIG_CHECK="~PCI_MSI"
	linux-info_pkg_setup
}

src_prepare() {
	# Follow systemd policies
	# https://wiki.gentoo.org/wiki/Project:Systemd/Ebuild_policy
	sed \
		-e 's/ $IRQBALANCE_ARGS//' \
		-e '/EnvironmentFile/d' \
		-i misc/irqbalance.service || die

	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with caps libcap-ng)
		$(use_enable numa)
		$(use_with systemd)
		$(use_enable thermal)
		$(use_with tui irqbalance-ui)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	newinitd "${FILESDIR}"/irqbalance.init.4 irqbalance
	newconfd "${FILESDIR}"/irqbalance.confd-1 irqbalance
	systemd_dounit misc/irqbalance.service
	udev_dorules misc/90-irqbalance.rules
}

pkg_postinst() {
	optfeature "thermal events support (requires USE=thermal)" sys-power/thermald
}
