# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

ESVN_REPO_URI="https://pspdftool.svn.sourceforge.net/svnroot/pspdftool/trunk"
ESVN_PROJECT="pspdftool"

[[ "${PV}" == "9999" ]] && EXTRA_ECLASS="subversion"
inherit autotools ${EXTRA_ECLASS}
unset EXTRA_ECLASS

DESCRIPTION="Tool for prepress preparation of PDF and PostScript documents"
HOMEPAGE="http://sourceforge.net/projects/pspdftool"
[[ "${PV}" == "9999" ]] || SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
[[ "${PV}" == "9999" ]] || \
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="zlib"

DEPEND="zlib? ( sys-libs/zlib ) "
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf $(use_with zlib)
}

src_install() {
	default
	rm -rf "${ED}"/usr/share/doc/${PN}*
}
