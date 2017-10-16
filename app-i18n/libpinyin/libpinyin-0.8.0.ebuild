# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils

DESCRIPTION="Library for Chinese pinyin input methods"
HOMEPAGE="https://github.com/libpinyin/libpinyin"
SRC_URI="mirror://github/${PN}/${PN}/${PN}-lite-${PV}.tar.gz -> ${P}.tar
	mirror://github/${PN}/${PN}/model.text.tar.gz"

LICENSE="GPL-2+"
SLOT="0/2"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE=""

RDEPEND="sys-libs/db:=
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	virtual/libintl
	virtual/pkgconfig"

src_prepare() {
	ln -s "${DISTDIR}"/model.text.tar.gz data || die
	sed -e '/wget/d' -i data/Makefile.am || die
	epatch_user
	eautoreconf
}

src_install() {
	default
	prune_libtool_files
}
