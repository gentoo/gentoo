# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Allows you to prompt for user input on the command line"
HOMEPAGE="https://github.com/Seldaek/cli-prompt"
SRC_URI="https://github.com/Seldaek/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader"

src_install() {
	insinto "/usr/share/php/Seld/CliPrompt"
	doins -r src/. "${FILESDIR}"/autoload.php
	dodoc README.md
}
