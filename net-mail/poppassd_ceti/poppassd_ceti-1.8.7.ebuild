# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pam readme.gentoo-r1

# Long ago it was just "poppassd", but upstream now seems to have
# settled on "poppassd-ceti" (instead of "poppassd_ceti" or no suffix).
MY_PN="poppassd-ceti"
MY_P="${MY_PN}-${PV}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="Password change daemon with PAM support"
HOMEPAGE="https://github.com/kravietz/poppassd-ceti"
SRC_URI="https://github.com/kravietz/${MY_PN}/releases/download/v${PV}/${MY_P}.tar.xz"

# Strictly speaking the "or later version" clarification was only
# added upstream after 1.8.7:
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="sys-libs/pam"
RDEPEND="${DEPEND}"

FORCE_PRINT_ELOG=1  # possibly remove in the next bump
DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="poppassd is installed, but has to be run as root to work.

Most commonly a front end would require sys-apps/xinetd and connect to
port 106: For this, edit /etc/xinetd.d/poppassd, install sys-apps/xinetd,
and start the xinetd service.

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

	exeinto /usr/sbin
	exeopts -o root -g bin -m 500
	doexe poppassd
}

pkg_postinst() {
	readme.gentoo_print_elog
}
