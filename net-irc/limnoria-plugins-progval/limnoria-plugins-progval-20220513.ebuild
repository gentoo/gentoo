# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vcs-snapshot

COMMIT="d09a37d7caf524a4a4b70f036038aaa9fd838974"

DESCRIPTION="Collection of plugins for Supybot/Limnoria I wrote or forked"
HOMEPAGE="https://github.com/ProgVal/Supybot-plugins"
SRC_URI="https://github.com/ProgVal/Supybot-plugins/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD GPL-2 GPL-3 MIT"
KEYWORDS="~amd64 ~riscv ~x86"
SLOT=0

RDEPEND="net-irc/limnoria"

DOCS=(
	"README.md"
	"requirements.txt"
)

src_install() {
	default
	insinto /usr/share/limnoria-extra-plugins/ProgVal
	doins -r *
}

pkg_postinst() {
	elog "Before this plugin can be used, your bot will need to be told where to"
	elog "load it from. To do this, add /usr/share/limnoria-extra-plugins/ProgVal when"
	elog "prompted during the bot creation wizard, or add it to a running bots config"
	elog "with the command"
	elog
	elog "    config directories.plugins [config directories.plugins], /usr/share/limnoria-extra-plugins/ProgVal"
}
