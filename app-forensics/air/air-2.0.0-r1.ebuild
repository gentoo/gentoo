# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

DESCRIPTION="A GUI front-end to dd/dc3dd"
HOMEPAGE="http://air-imager.sourceforge.net/"
SRC_URI="mirror://sourceforge/air-imager/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="crypt"

# coreutils are needed for /usr/bin/split binary
COMMON_DEPEND="userland_GNU? ( sys-apps/coreutils )"

DEPEND="${COMMON_DEPEND}
	>=dev-perl/perl-tk-804.27.0
	userland_GNU? ( app-arch/sharutils )"

# TODO: air can utilize dc3dd, but it is not in portage ATM
RDEPEND="${COMMON_DEPEND}
	app-arch/mt-st
	net-analyzer/netcat
	crypt? ( net-analyzer/cryptcat )"

src_install() {
	export PERLTK_VER=`perl -e 'use Tk;print "$Tk::VERSION";'`

	env INTERACTIVE=no INSTALL_DIR="${D}/usr" TEMP_DIR="${T}" \
		FINAL_INSTALL_DIR=/usr \
		./install-${P} \
		|| die "failed to install - please attach ${T}/air-install.log to a bug report at http://bugs.gentoo.org"

	dodoc README

	dodoc "${T}/air-install.log"

	fowners root:users /usr/share/air/logs
	fperms ug+rwx /usr/share/air/logs
	fperms a+x /usr/bin/air

	mkfifo "${D}usr/share/air/air-fifo" || die "pipe creation failed"
	fperms ug+rw /usr/share/air/air-fifo
	fowners root:users /usr/share/air/air-fifo
}

pkg_postinst() {
	elog "The author, steve@unixgurus.com, would appreciate an email of the install file /usr/share/doc/${PF}/air-install.log"
}
