# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://github.com/blogc/blogc-git-receiver.git
		https://github.com/blogc/blogc-git-receiver.git"
	inherit git-r3 autotools
fi

DESCRIPTION="A simple login shell/git hook to deploy blogc websites"
HOMEPAGE="https://github.com/blogc/blogc-git-receiver"

SRC_URI="https://github.com/blogc/${PN}/releases/download/v${PV}/${P}.tar.xz"
KEYWORDS="~amd64 ~x86"
if [[ ${PV} = *9999* ]]; then
	SRC_URI=""
	KEYWORDS=""
	DEPEND="=dev-libs/squareball-9999"
else
	DEPEND=">=dev-libs/squareball-0.1"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="${DEPEND}
	dev-vcs/git"

src_prepare() {
	[[ ${PV} = *9999* ]] && eautoreconf
	default
}

src_configure() {
	econf \
		--with-squareball=system
}
