# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake systemd

DESCRIPTION="Automated port scan detector and response tool"
HOMEPAGE="https://portsentry.xyz https://github.com/portsentry/portsentry"
SRC_URI="https://github.com/portsentry/portsentry/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+pcap systemd"

DEPEND="
	pcap? ( net-libs/libpcap )
	systemd? ( sys-apps/systemd )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUSE_PCAP=$(usex pcap)
		-DUSE_SYSTEMD=$(usex systemd)
		# Portage installs the license via the LICENSE variable.
		-DINSTALL_LICENSE=OFF
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		# The build uses the relative SYSCONFDIR, which would otherwise
		# resolve to ${prefix}/etc (/usr/etc). Force a real /etc.
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
	)

	# USE_SYSTEMD=ON is a fatal error unless the unit dir is provided.
	if use systemd; then
		mycmakeargs+=( -DSYSTEMD_SYSTEM_UNIT_DIR="$(systemd_get_systemunitdir)" )
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# portsentry 2.x is a single config-driven daemon; the init script and
	# confd are rewritten for its CLI (not the old 1.x per-mode invocation).
	newinitd "${FILESDIR}"/portsentry.initd portsentry
	newconfd "${FILESDIR}"/portsentry.confd portsentry
}
