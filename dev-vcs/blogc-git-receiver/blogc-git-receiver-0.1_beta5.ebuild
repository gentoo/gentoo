# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://github.com/blogc/blogc-git-receiver.git
		https://github.com/blogc/blogc-git-receiver.git"
	inherit git-r3 autotools
fi

DESCRIPTION="A simple login shell/git hook to deploy blogc websites"
HOMEPAGE="https://github.com/blogc/blogc-git-receiver"

MY_PV="${PV/_/-}"
MY_PV="${MY_PV/beta/beta.}"

MY_P="${PN}-${MY_PV}"

SRC_URI="https://github.com/blogc/${PN}/releases/download/v${MY_PV}/${MY_P}.tar.xz"
KEYWORDS="~amd64 ~x86"
if [[ ${PV} = *9999* ]]; then
	SRC_URI=""
	KEYWORDS=""
else
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-vcs/git"
DEPEND="${RDEPEND}"

src_prepare() {
	[[ ${PV} = *9999* ]] && eautoreconf
	default
}
