# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic out-of-source systemd

DESCRIPTION="Thermal daemon for Intel architectures"
HOMEPAGE="https://01.org/linux-thermal-daemon"
SRC_URI="https://github.com/01org/thermal_daemon/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/dbus-glib:=
	dev-libs/glib:=
	dev-libs/libxml2:=
	sys-apps/dbus:="
DEPEND="${RDEPEND}
	dev-util/glib-utils"

S=${WORKDIR}/thermal_daemon-${PV}
DOCS=( thermal_daemon_usage.txt README.txt )

src_prepare() {
	eapply "${FILESDIR}/${P}-size_t-format.patch"
	default
	eautoreconf
}

my_src_configure() {
	# bug 618948
	append-cxxflags -std=c++14

	ECONF_SOURCE="${S}" econf \
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
}

my_src_install_all() {
	einstalldocs

	rm -rf "${ED%/}"/etc/init || die
	doinitd "${FILESDIR}"/thermald
}
