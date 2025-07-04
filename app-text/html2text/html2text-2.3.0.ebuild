# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/grobian/html2text.git"
else
	SRC_URI="https://github.com/grobian/${PN}/releases/download/v${PV}/${P}.tar.gz"
	SRC_URI="https://gitlab.com/-/project/48313341/uploads/b7a99615c4419cf9a65dc24f12bae0d4/html2text-2.3.0.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

DESCRIPTION="HTML to text converter, aimed at email for clients like Mutt"
HOMEPAGE="https://gitlab.com/grobian/html2text"

LICENSE="GPL-2"
SLOT="0"

DEPEND="virtual/libiconv"
RDEPEND="${DEPEND}"

src_test() {
	emake check
}
