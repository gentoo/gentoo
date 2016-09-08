# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="KDE implementation of ssh-askpass with Kwallet integration"
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=50971&forumpage=0"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/50971-${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
SLOT="4"
IUSE="debug"

RDEPEND="net-misc/openssh"

CFG="ksshaskpass.sh"

src_prepare() {
	STARTUPDIR=/etc/kde/startup
	SHUTDOWNDIR=/etc/kde/shutdown

	kde4-base_src_prepare
}

src_install() {
	kde4-base_src_install

	cat <<-EOF > "${T}/${CFG}"
export SSH_ASKPASS="${PREFIX}/bin/ksshaskpass"
EOF
	insinto "${STARTUPDIR}"
	doins "${T}/${CFG}"
}

pkg_postinst() {
	kde4-base_pkg_postinst

	elog
	elog "In order to have ksshagent start at kde startup,"
	elog "edit ${STARTUPDIR}/agent-startup.sh and uncomment"
	elog "the lines enabling ssh-agent."
	elog
	elog "If you do so, do not forget to uncomment the respective"
	elog "lines in ${SHUTDOWNDIR}/agent-shutdown.sh to"
	elog "properly kill the agent when the session ends."
	elog
	elog "${P} has been installed as your default askpass application in KDE4 session."
	elog "If it's not desired, point the one you want to use in ${STARTUPDIR}/${CFG}"
	elog
}
