# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools ltprune

MODELV=14

DESCRIPTION="Library to deal with pinyin"
HOMEPAGE="https://github.com/libpinyin/libpinyin"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	mirror://sourceforge/${PN}/models/model${MODELV}.text.tar.gz"

LICENSE="GPL-2"
SLOT="0/12"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	sys-libs/db:="

DEPEND="${RDEPEND}
	virtual/libintl
	virtual/pkgconfig"

src_prepare() {
	default
	ln -s "${DISTDIR}"/model${MODELV}.text.tar.gz data || die
	sed -i "/wget/d" data/Makefile.am || die
	eautoreconf
}

src_install() {
	default
	prune_libtool_files
}
