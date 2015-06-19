# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/cgmanager/cgmanager-0.36-r1.ebuild,v 1.2 2015/02/28 19:57:33 maekke Exp $

EAPI="5"

DESCRIPTION="Control Group manager daemon"
HOMEPAGE="https://linuxcontainers.org/cgmanager/introduction/"
SRC_URI="https://linuxcontainers.org/downloads/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="
	sys-libs/libnih[dbus]
	sys-apps/dbus"
DEPEND="${RDEPEND}"

src_prepare() {
	# systemd expects files in /sbin but we will have them in /usr/sbin
	pushd config/init/systemd > /dev/null || die
	sed -i -e "s@sbin@usr/&@" {${PN},cgproxy}.service || \
		die "Failed to fix paths in systemd service files"
	popd > /dev/null || die
}

src_configure() {
	econf \
		--with-distro=gentoo \
		--with-init-script=systemd
}

src_install () {
	default
	# I see no reason to have the tests in the filesystem. Drop them
	rm -r "${D}"/usr/share/${PN}/tests || die "Failed to remove ${PN} tests"
	# FIXME: openRC init scripts are not well tested
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newinitd "${FILESDIR}"/cgproxy.initd cgproxy
}
