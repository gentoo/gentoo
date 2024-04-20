# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Library that renders module files to PCM data"
HOMEPAGE="https://github.com/libxmp/libxmp"

if [[ ${PV} == *9999 ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/libxmp/libxmp.git"
else
	SRC_URI="https://github.com/libxmp/${PN}/releases/download/${P}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

# bzip2 depacker code is 0BSD
LICENSE="LGPL-2.1+ MIT 0BSD"
SLOT="0"

src_prepare() {
	default
	[[ ${PV} == *9999 ]] && eautoreconf
}

src_compile() {
	emake V=1
}
