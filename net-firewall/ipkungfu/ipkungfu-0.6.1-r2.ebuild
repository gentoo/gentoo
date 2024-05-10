# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A nice iptables firewall script"
HOMEPAGE="http://www.linuxkungfu.org/"
SRC_URI="http://www.linuxkungfu.org/ipkungfu/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"

DEPEND="net-firewall/iptables"
RDEPEND="${DEPEND}
	virtual/logger"

PATCHES=(
	"${FILESDIR}/${PN}_noiseless.patch"
)

src_install() {
	default

	# Install configuration files
	emake DESTDIR="${D}" install-config

	mv "${D}"/usr/share/doc/${P} "${D}"/usr/share/doc/${PF} || die

	# Install Gentoo init script
	newinitd "${FILESDIR}"/ipkungfu.init ipkungfu
}

pkg_postinst() {
	# Remove the cache dir so ipkungfu won't fail when running for
	# the first time, in case 0.6.0 was installed before.
	rm -rf /etc/ipkungfu/cache

	einfo "Be sure, before running ipkungfu, to edit the config files in:"
	einfo "/etc/ipkungfu/"
	einfo
	einfo "Also, be sure to run ipkungfu prior to rebooting,"
	einfo "especially if you you're updating from <0.6.0 to >=0.6.0."
	einfo "There are some significant configuration changes on this"
	einfo "release covered by the ipkungfu script."
}
