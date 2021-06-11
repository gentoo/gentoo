# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_IN_SOURCE_BUILD=1
inherit cmake pam readme.gentoo-r1 systemd

# Long ago it was just "poppassd", but upstream now seems to have
# settled on "poppassd-ceti" (instead of "poppassd_ceti" or no suffix).
MY_PN="poppassd-ceti"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Password change daemon with PAM support"
HOMEPAGE="https://github.com/kravietz/poppassd-ceti"
SRC_URI="https://github.com/kravietz/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# Tests seem to hang.
RESTRICT="test"

RDEPEND="sys-libs/pam"
DEPEND="${RDEPEND}
	test? ( app-admin/sudo )"

S="${WORKDIR}/${MY_P}"

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="poppassd is installed, but has to be run as root to work.

Most commonly a front end would require sys-apps/xinetd and connect to
port 106: For this, edit /etc/xinetd.d/poppassd, install sys-apps/xinetd,
and start the xinetd service.

If you use systemd, you may be able to use the installed poppassd.socket
and poppassd.service files instead of xinetd.  See README.md.bz2 and
systemd documentation.

Alternatively, a front end may be able to run it directly (if already
root), or might use app-admin/sudo.  To use sudo, you'll need to configure
/etc/sudoers with something similar to:

    apache ALL=(ALL)       NOPASSWD: /usr/sbin/poppassd

See also README.md.bz2 for related configuration and security
considerations.
"

src_install() {
	dodoc README.md
	readme.gentoo_create_doc

	pamd_mimic_system poppassd auth account password

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/poppassd.xinetd poppassd

	systemd_dounit etc/systemd/poppassd.{socket,service}

	exeinto /usr/sbin
	exeopts -o root -g bin -m 500
	doexe poppassd
}

pkg_postinst() {
	readme.gentoo_print_elog
}
