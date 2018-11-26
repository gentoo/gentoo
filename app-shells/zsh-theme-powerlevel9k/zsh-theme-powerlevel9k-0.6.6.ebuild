# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EXTRACT_DIR="powerlevel9k-0.6.6"

DESCRIPTION="Powerlevel9k theme for ZSH which uses Powerline Fonts"
HOMEPAGE="https://github.com/bhilburn/powerlevel9k"

KEYWORDS="~amd64"

SLOT="0"
LICENSE="MIT"

SRC_URI="https://github.com/bhilburn/powerlevel9k/archive/v${PV}.tar.gz -> ${P}.tar.gz"

RDEPEND="media-fonts/powerline-symbols"

S="${WORKDIR}"

src_install()
{
	insinto "/usr/share/zsh-theme-powerlevel9k"
	doins -r {"${EXTRACT_DIR}/debug","${EXTRACT_DIR}/docker","${EXTRACT_DIR}/functions","${EXTRACT_DIR}/shunit2","${EXTRACT_DIR}/test","${EXTRACT_DIR}/test-bsd-vm","${EXTRACT_DIR}/test-vm","${EXTRACT_DIR}/test-vm-providers"}
	doins "${EXTRACT_DIR}/powerlevel9k.zsh-theme"
	doins "${EXTRACT_DIR}/prompt_powerlevel9k_setup"
	doins "${EXTRACT_DIR}/README.md"
	doins "${EXTRACT_DIR}/test-in-docker"
	doins "${EXTRACT_DIR}/TESTS.md"
}

pkg_postinst() {
	elog "To use powerlevel9k zsh theme,"
	elog "add 'source \"/usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme\"'"
	elog "to your .zshrc file and don't forget to enable powerline fonts with"
	elog "'eselect fontconfig' command."
}
