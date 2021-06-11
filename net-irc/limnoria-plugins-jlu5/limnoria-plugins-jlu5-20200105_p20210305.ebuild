# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vcs-snapshot

COMMIT="f9b6b4c24786460a4ad12d39af4d7865ebdf2904"

DESCRIPTION="A collection of plugins for the Limnoria IRC bot."
HOMEPAGE="https://github.com/jlu5/SupyPlugins"
SRC_URI="https://github.com/jlu5/SupyPlugins/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD GPL-2+"
KEYWORDS="~amd64 ~x86"
SLOT=0

RDEPEND="
	net-irc/limnoria
	dev-python/beautifulsoup
"

DOCS=(
	"README.md"
	"requirements.txt"
)

src_install() {
	default
	insinto /usr/share/limnoria-extra-plugins/jlu5
	doins -r *
}

pkg_postinst() {
	elog "Before these plugins can be used, your bot will need to be told where to"
	elog "load them from. To do this, add /usr/share/limnoria-extra-plugins/jlu5 when"
	elog "prompted during the bot creation wizard, or add it to a running bots config"
	elog "with the command"
	elog
	elog "    config directories.plugins [config directories.plugins], /usr/share/limnoria-extra-plugins/jlu5"
}
