# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vcs-snapshot

COMMIT="7a60d9912171b3f6fb927b03c18710773d7f4227"

DESCRIPTION="supybot ban management and channel flood/spam/repeat protections plugin"
HOMEPAGE="https://github.com/ncoevoet/ChanTracker"
SRC_URI="https://github.com/ncoevoet/ChanTracker/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT=0

RDEPEND="net-irc/limnoria"

DOCS="README.md"

src_install() {
	default
	insinto /usr/share/limnoria-extra-plugins/ncoevoet/ChanTracker
	doins -r *
}

pkg_postinst() {
	elog "Before this plugin can be used, your bot will need to be told where to"
	elog "load it from. To do this, add /usr/share/limnoria-extra-plugins/ncoevoet when"
	elog "prompted during the bot creation wizard, or add it to a running bots config"
	elog "with the command"
	elog
	elog "    config directories.plugins [config directories.plugins], /usr/share/limnoria-extra-plugins/ncoevoet"
}
