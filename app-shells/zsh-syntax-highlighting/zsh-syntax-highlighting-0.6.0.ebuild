# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Fish shell like syntax highlighting for Zsh"
HOMEPAGE="https://github.com/zsh-users/zsh-syntax-highlighting"
SRC_URI="https://github.com/zsh-users/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND=">app-shells/zsh-4.3.11"

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" DOC_DIR="${D}/usr/share/doc/${PF}" install
	dosym "../../../${PN}/${PN}.zsh" "/usr/share/zsh/plugins/${PN}/${PN}.zsh"
}
