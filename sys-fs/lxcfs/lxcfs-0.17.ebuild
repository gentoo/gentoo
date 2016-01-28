# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils systemd vcs-snapshot
DESCRIPTION="FUSE filesystem for LXC"
HOMEPAGE="https://linuxcontainers.org/lxcfs/introduction/"
LICENSE="Apache-2.0"
SLOT="0"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/lxc/lxcfs.git"
	EGIT_BRANCH="master"
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/lxc/lxcfs/archive/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

#IUSE="test"

# Omit all dbus.  Upstream appears to require it because systemd, but
# lxcfs makes no direct use of dbus.
RDEPEND="
	dev-libs/glib:2
	sys-fs/fuse
	virtual/pam
"
DEPEND="
	sys-apps/help2man
	${RDEPEND}
"

src_prepare() {
	./bootstrap.sh || die "Failed to bootstrap configure files"
}

src_configure() {
	econf --localstatedir=/var
}

# Test suite fails for me
# src_test() {
# 	emake tests
# 	tests/main.sh || die "Tests failed"
# }

src_install() {
	default
	dodir /var/lib/lxcfs
	newinitd "${FILESDIR}"/${P}.initd lxcfs
	systemd_newunit "${FILESDIR}/${P}.service" lxcfs.service
}
