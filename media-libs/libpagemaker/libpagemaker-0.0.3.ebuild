# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="git://gerrit.libreoffice.org/${PN}.git"
[[ ${PV} == 9999 ]] && inherit autotools git-r3

DESCRIPTION="C++ Library that parses the file format of Aldus/Adobe PageMaker documents."
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/${PN}"
[[ ${PV} == 9999 ]] || SRC_URI="http://dev-www.libreoffice.org/src/${PN}/${P}.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"

[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="debug doc tools"

RDEPEND="
	dev-libs/librevenge
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.47
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_prepare() {
	eapply_user
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--disable-werror \
		$(use_enable tools) \
		$(use_with doc docs)
}
