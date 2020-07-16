# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools pam

DESCRIPTION="Control Group manager daemon"
HOMEPAGE="https://linuxcontainers.org/cgmanager/introduction/"
SRC_URI="https://linuxcontainers.org/downloads/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 s390 sparc x86"
IUSE="pam selinux"

RDEPEND="sys-libs/libnih[dbus]
	sys-apps/dbus
	selinux? ( sec-policy/selinux-cgmanager )"
DEPEND="${RDEPEND}"

src_prepare() {
	eapply_user

	# systemd expects files in /sbin but we will have them in /usr/sbin
	pushd config/init/systemd > /dev/null || die
	sed -i -e "s@sbin@usr/&@" {${PN},cgproxy}.service || \
		die "Failed to fix paths in systemd service files"
	popd > /dev/null || die

	eautoreconf
}

src_configure() {
	econf \
		--with-distro=gentoo \
		--with-pamdir="$(usex pam $(getpam_mod_dir) none)" \
		--with-init-script=systemd
}

src_install() {
	default

	# I see no reason to have the tests in the filesystem. Drop them
	rm -r "${D}"/usr/share/${PN}/tests || die "Failed to remove ${PN} tests"

	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	newinitd "${FILESDIR}"/cgproxy.initd-r1 cgproxy
}
