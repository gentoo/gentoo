# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Fancy symbols for prompt inspired by powerline."
HOMEPAGE="https://github.com/gabrielelana/awesome-terminal-fonts"
KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="0"
SRC_URI="https://github.com/gabrielelana/awesome-terminal-fonts/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"
EXTRACT_DIR="awesome-terminal-fonts-${PV}"

src_install()
{
	insinto "/usr/share/fonts/awesome-terminal-fonts"
	doins "${EXTRACT_DIR}/fonts/devicons-regular.ttf"
	doins "${EXTRACT_DIR}/fonts/fontawesome-regular.ttf"
	doins "${EXTRACT_DIR}/fonts/octicons-regular.ttf"
	doins "${EXTRACT_DIR}/fonts/pomicons-regular.ttf"
	doins "${EXTRACT_DIR}/LICENSE"
	doins "${EXTRACT_DIR}/README.md"
	insinto "/etc/fonts/conf.d/"
	doins "${EXTRACT_DIR}/config/10-symbols.conf"
}
