# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

if [[ ${PV} == "9999" ]]; then
	ESVN_REPO_URI="https://svn.code.sf.net/p/pspdftool/code/trunk"
	inherit subversion
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Tool for prepress preparation of PDF and PostScript documents"
HOMEPAGE="https://sourceforge.net/projects/pspdftool"

LICENSE="GPL-2"
SLOT="0"
IUSE="zlib"

DEPEND="zlib? ( sys-libs/zlib ) "
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_with zlib)
}

src_install() {
	default
	rm -rf "${ED}"/usr/share/doc/${PN}*
}
