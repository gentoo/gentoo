# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Minimal mDNS resolver (and announcer) library"
HOMEPAGE="https://videolabs.io"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/videolabs/${PN}"
else
	SRC_URI="https://github.com/videolabs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm arm64 ppc ppc64 x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-0.0.9-null-addr-fix.patch" )

src_prepare(){
	default
	eautoreconf
}
