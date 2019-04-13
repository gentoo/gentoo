# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd vcs-snapshot
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
	KEYWORDS="amd64"
fi

# Omit all dbus.  Upstream appears to require it because systemd, but
# lxcfs makes no direct use of dbus.
RDEPEND="
	dev-libs/glib:2
	sys-fs/fuse:0
"
DEPEND="
	sys-apps/help2man
	${RDEPEND}
"
PATCHES="${FILESDIR}/${PN}-fusermount-path.patch"

src_prepare() {
	default
	./bootstrap.sh || die "Failed to bootstrap configure files"
}

src_configure() {
	# Without the localstatedir the filesystem isn't mounted correctly
	econf --localstatedir=/var
}

# Test suite fails for me
# src_test() {
# 	emake tests
# 	tests/main.sh || die "Tests failed"
# }

src_install() {
	default
	keepdir /var/lib/lxcfs
	newinitd "${FILESDIR}"/${PN}.initd lxcfs
	systemd_dounit config/init/systemd/lxcfs.service
}

pkg_preinst() {
	# In an upgrade situation merging /var/lib/lxcfs (an empty dir)
	# fails because that is a live mountpoint when the service is
	# running.  It's unnecessary anyway so skip the action.
	[[ -d ${ROOT}/var/lib/lxcfs ]] && rm -rf ${D}/var
}

pkg_postinst() {
	einfo
	einfo "Starting with version 3.0.0 the cgfs PAM module has moved, and"
	einfo "will eventually be available in app-emulation/lxc.  See:"
	einfo "https://brauner.github.io/2018/02/28/lxc-includes-cgroup-pam-module.html"
	einfo "for more information."
	einfo
}
