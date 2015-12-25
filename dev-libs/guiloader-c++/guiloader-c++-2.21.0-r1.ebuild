# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit eutils flag-o-matic

DESCRIPTION="C++ binding to GuiLoader library"
HOMEPAGE="http://www.crowdesigner.org"
SRC_URI="https://nothing-personal.googlecode.com/files/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

LANGS="ru"

RDEPEND=">=dev-libs/guiloader-2.21
	>=dev-cpp/gtkmm-2.22:2.4
	>=dev-cpp/glibmm-2.24:2"
DEPEND="${RDEPEND}
	dev-libs/boost
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.18 )"

for x in ${LANGS}; do
	IUSE="${IUSE} linguas_${x}"
done

src_configure() {
	append-cxxflags -std=c++11
	econf $(use_enable nls)
}

src_install() {
	default
	prune_libtool_files
	dodoc doc/{authors.txt,news.en.txt,readme.en.txt}
}
