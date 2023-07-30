# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/grobian/html2text.git"
else
	SRC_URI="https://github.com/grobian/${PN}/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

DESCRIPTION="HTML to text converter"
HOMEPAGE="https://github.com/grobian/html2text"

LICENSE="GPL-2"
SLOT="0"

DEPEND="virtual/libiconv"
RDEPEND="${DEPEND}"

src_test() {
	emake check
}
