# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/bitflu/bitflu-1.52.ebuild,v 1.1 2015/07/12 13:44:09 blueness Exp $

EAPI=5

inherit user

DESCRIPTION="BitTorrent client, written in Perl and is designed to run as a daemon"
HOMEPAGE="http://bitflu.workaround.ch"
SRC_URI="http://bitflu.workaround.ch/bitflu/${P}.tgz"

LICENSE="Artistic-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-perl/Danga-Socket
	dev-perl/Sys-Syscall"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup bitflu
	enewuser bitflu -1 -1 /var/lib/bitflu bitflu
}

src_compile() { :; }

PLUGINS="/usr/lib/bitflu"
HOMEDIR="/var/lib/bitflu"
CONFDIR="/etc/bitflu"
LOGDIR="/var/log/bitflu"

src_install() {
	# executable daemon
	dosbin bitflu.pl

	# plugins
	insinto "${PLUGINS}"
	doins -r plugins

	# working dir
	dodir "${HOMEDIR}"
	fowners bitflu:bitflu "${HOMEDIR}"
	fperms 775 "${HOMEDIR}"

	# config file
	insinto "${CONFDIR}"
	fowners bitflu:bitflu "${CONFDIR}"
	fperms 775 "${CONFDIR}"
	doins "${FILESDIR}"/bitflu.config
	fowners bitflu:bitflu "${CONFDIR}"/bitflu.config
	fperms 664 "${CONFDIR}"/bitflu.config

	# log file
	dodir "${LOGDIR}"
	fowners bitflu:bitflu "${LOGDIR}"
	fperms 775 "${LOGDIR}"

	# docs
	dodoc bitflu.config.example ChangeLog.txt CONTRIBUTING README_IPv6.txt \
		README.txt Documentation/bitflu-internals.txt

	newinitd "${FILESDIR}"/bitflu.initd bitflu
}

pkg_postinst() {
	ewarn "Note: At startup, or at the user's request, ${PN} (re)reads its"
	ewarn "configuration file and overwrites it with its own sanitized"
	ewarn "version.  A backup is created in the configuration directory,"
	ewarn "/etc/${PN}, but that file will subseqently be overwritten if"
	ewarn "a further backup is made.  You may want to keep your own backup."
	ewarn "A prestine example with comments may be found in /usr/share/doc/${P}."
}
