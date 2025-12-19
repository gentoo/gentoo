# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/grobian/html2text.git"
else
	SRC_URI="https://gitlab.com/-/project/48313341/uploads/8526650dd42218b3493ce7ca0a3eeb1e/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
fi

DESCRIPTION="HTML to text converter, aimed at email for clients like Mutt"
HOMEPAGE="https://gitlab.com/grobian/html2text"

LICENSE="GPL-2"
SLOT="0"
IUSE="+curl"

DEPEND="virtual/libiconv
	curl? ( net-misc/curl )"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_with curl libcurl) || die
}

src_test() {
	emake check
}
