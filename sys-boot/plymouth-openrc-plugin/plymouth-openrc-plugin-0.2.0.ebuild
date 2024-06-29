# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Plymouth plugin for OpenRC"
HOMEPAGE="https://github.com/Kangie/plymouth-openrc-plugin"
SRC_URI="https://github.com/Kangie/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug"

DEPEND="sys-apps/openrc"
RDEPEND="${DEPEND}
	sys-boot/plymouth
	!sys-apps/systemd"

src_configure() {
	local emesonargs=(
		-Ddebug=$(usex debug true false)
	)
	meson_src_configure
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		ewarn "The 'rc_interactive' feature in /etc/rc.conf must be disabled"
		ewarn "for Plymouth work properly with OpenRC init system."
	fi
}
