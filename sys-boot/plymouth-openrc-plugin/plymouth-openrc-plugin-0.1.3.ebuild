# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Plymouth plugin for OpenRC"
HOMEPAGE="https://github.com/Kangie/plymouth-openrc-plugin"
SRC_URI="https://github.com/Kangie/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="sys-apps/openrc"
RDEPEND="${DEPEND}
	sys-boot/plymouth
	!sys-apps/systemd"

src_install() {
	insinto /$(get_libdir)/rc/plugins
	doins plymouth.so
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		ewarn "You need to disable 'rc_interactive' feature in /etc/rc.conf to make"
		ewarn "Plymouth work properly with OpenRC init system."
	fi
}
