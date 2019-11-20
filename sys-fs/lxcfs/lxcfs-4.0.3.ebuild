# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd

DESCRIPTION="FUSE filesystem for LXC"
HOMEPAGE="https://linuxcontainers.org/lxcfs/introduction/ https://github.com/lxc/lxcfs/"
SRC_URI="https://github.com/lxc/lxcfs/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Omit all dbus.  Upstream appears to require it because systemd, but
# lxcfs makes no direct use of dbus.
# acct-group/lxd needed for the fowners below.
RDEPEND="dev-libs/glib:2
	sys-fs/fuse:0"
DEPEND="${RDEPEND}"
BDEPEND="sys-apps/help2man"

RESTRICT="test"

S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Without the localstatedir the filesystem isn't mounted correctly
	# Without with-distro ./configure will fail when cross-compiling
	econf --localstatedir=/var --with-distro=gentoo
}

src_test() {
	emake tests
	tests/main.sh || die "Tests failed"
}

src_install() {
	default

	# Getting weird file collisions, 
	# keepdir /var/lib/lxcfs
	# fowners -R root:lxd /var/lib/lxcfs

	newconfd "${FILESDIR}"/lxcfs-4.0.0.confd lxcfs
	newinitd "${FILESDIR}"/lxcfs-4.0.0.initd lxcfs
	systemd_dounit config/init/systemd/lxcfs.service
}
