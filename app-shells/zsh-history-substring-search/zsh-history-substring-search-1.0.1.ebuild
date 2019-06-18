# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="ZSH port of Fish history search (up arrow)"
HOMEPAGE="https://github.com/zsh-users/zsh-history-substring-search"
SRC_URI="https://github.com/zsh-users/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

RDEPEND=">=app-shells/zsh-4.3"

src_install() {
	einstalldocs

	insinto "/usr/share/zsh/plugins/${PN}"
	doins "${PN}.zsh"
}

pkg_postinst() {
	einfo "For use this script,  load it into your interactive  ZSH  session:"
	einfo "    source /usr/share/zsh/plugins/${PN}/${PN}.zsh"
	einfo
	ewarn "If you want to use zsh-syntax-highlighting along with this script,"
	ewarn "then make sure that you load it before you load this script."
	einfo
	einfo "For further information,  please read the README.md file installed"
	einfo "in /usr/share/doc/${PF}"
}
