# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vcs-snapshot

MY_PV="${PV:0:4}.${PV:4:2}.${PV:6:2}"
COMMIT="9f6e6bff96fa7c849123054cd656f6e4af2cec94"

DESCRIPTION="A collection of plugins for the Limnoria IRC bot"
HOMEPAGE="https://github.com/jlu5/SupyPlugins"
SRC_URI="https://github.com/jlu5/SupyPlugins/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD GPL-2+"
KEYWORDS="~amd64 ~riscv ~x86"
SLOT=0

RDEPEND="
	net-irc/limnoria
	dev-python/beautifulsoup4
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
