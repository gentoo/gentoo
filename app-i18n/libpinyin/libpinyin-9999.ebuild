# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/libpinyin/libpinyin"
fi

LIBPINYIN_MODEL_VERSION="14"

DESCRIPTION="Library to deal with pinyin"
HOMEPAGE="https://github.com/libpinyin/libpinyin https://sourceforge.net/projects/libpinyin/"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi
SRC_URI+=" mirror://sourceforge/${PN}/models/model${LIBPINYIN_MODEL_VERSION}.text.tar.gz -> ${PN}-model${LIBPINYIN_MODEL_VERSION}.text.tar.gz"

LICENSE="GPL-3+"
SLOT="0/13"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/glib:2
	sys-libs/db:="

DEPEND="${RDEPEND}
	virtual/libintl
	virtual/pkgconfig"

src_unpack() {
	if [[ "${PV}" == "9999" ]]; then
		git-r3_src_unpack
	else
		unpack ${P}.tar.gz
	fi
}

src_prepare() {
	default

	ln -s "${DISTDIR}/${PN}-model${LIBPINYIN_MODEL_VERSION}.text.tar.gz" "data/model${LIBPINYIN_MODEL_VERSION}.text.tar.gz" || die
	sed -e "/^\twget .*\/model${LIBPINYIN_MODEL_VERSION}\.text\.tar\.gz$/d" -i data/Makefile.am || die

	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${D}" -name "*.la" -delete || die
}
