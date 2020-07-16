# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info systemd toolchain-funcs

DESCRIPTION="Performance analysis and visualization of the system boot process"
HOMEPAGE="https://github.com/mmeeks/bootchart/"
SRC_URI="https://github.com/mmeeks/bootchart/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"

RESTRICT="test"

RDEPEND="
	!app-benchmarks/bootchart
	sys-apps/lsb-release"

S="${WORKDIR}"/${PN%2}-${PV}

CONFIG_CHECK="~PROC_EVENTS ~TASKSTATS ~TASK_DELAY_ACCT ~TMPFS"

PATCHES=(
	"${FILESDIR}"/${PN}-0.14.7-sysmacros.patch # bug 579922
	"${FILESDIR}"/${P}-no-compressed-man.patch
)

src_prepare() {
	default
	tc-export CC
	sed -i \
		-e "/^install/s:py-install-compile::g" \
		-e "/^SYSTEMD_UNIT_DIR/s:=.*:= $(systemd_get_systemunitdir):g" \
		Makefile || die
	sed -i \
		-e '/^EXIT_PROC/s:^.*$:EXIT_PROC="agetty mgetty mingetty:g' \
		bootchartd.conf bootchartd.in || die
}

src_install() {
	export DOCDIR=/usr/share/doc/${PF}
	default

	# Note: LIBDIR is hardcoded as /lib in collector/common.h, so we shouldn't
	# just change it. Since no libraries are installed, /lib is fine.
	keepdir /lib/bootchart/tmpfs

	newinitd "${FILESDIR}"/${PN}.init ${PN}
}

pkg_postinst() {
	elog "If you are using an initrd during boot"
	elog "please add the init script to your default runlevel"
	elog "rc-update add bootchart2 default"
}
