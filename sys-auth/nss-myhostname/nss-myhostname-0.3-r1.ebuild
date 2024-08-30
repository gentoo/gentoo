# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Name Service Switch module for resolving the local hostname"
HOMEPAGE="https://0pointer.de/lennart/projects/nss-myhostname/"
SRC_URI="https://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ppc ppc64 ~riscv sparc x86"

RDEPEND="!>=sys-apps/systemd-197"

src_prepare() {
	# The documentation in doc/ is just the README file in other formats
	sed -e 's:SUBDIRS *= *doc:SUBDIRS =:' -i Makefile.{am,in} ||
		die "sed failed"
	default
}

src_configure() {
	econf --disable-lynx
}

pkg_postinst() {
	elog "You must modify your name service switch lookup file to enable"
	elog "nss-myhostname. To do so, add 'myhostname' to the hosts line in"
	elog "/etc/nsswitch.conf"
	elog
	elog "An example hosts line looks like this:"
	elog "hosts:      files dns myhostname"
	elog
}
