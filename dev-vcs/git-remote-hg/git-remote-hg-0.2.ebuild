# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=(python2_7)

DESCRIPTION="Semi-official Mercurial bridge from Git project"
HOMEPAGE="https://github.com/felipec/git-remote-hg"
SRC_URI="https://github.com/felipec/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-vcs/git
		dev-vcs/mercurial"
RDEPEND="${DEPEND}"

# Most (21/25) tests fail:
RESTRICT="test"

src_install() {
	dobin git-remote-hg
}
