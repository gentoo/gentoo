# Copyright 2012-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/libpinyin/libpinyin"
fi

LIBPINYIN_MODEL_VERSION="19"

DESCRIPTION="Libraries for handling of Hanyu Pinyin and Zhuyin Fuhao"
HOMEPAGE="https://github.com/libpinyin/libpinyin https://sourceforge.net/projects/libpinyin/"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/libpinyin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi
SRC_URI+=" mirror://sourceforge/${PN}/models/model${LIBPINYIN_MODEL_VERSION}.text.tar.gz -> ${PN}-model${LIBPINYIN_MODEL_VERSION}.text.tar.gz"

LICENSE="GPL-3+"
SLOT="0/13"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 x86"
IUSE=""

BDEPEND="virtual/pkgconfig"
DEPEND="dev-libs/glib:2
	sys-libs/db:="
RDEPEND="${DEPEND}"

src_unpack() {
	if [[ "${PV}" == "9999" ]]; then
		git-r3_src_unpack
	else
		unpack ${P}.tar.gz
	fi
}

src_prepare() {
	default

	sed -e "/^\twget .*\/model${LIBPINYIN_MODEL_VERSION}\.text\.tar\.gz$/d" -i data/Makefile.am || die
	ln -s "${DISTDIR}/${PN}-model${LIBPINYIN_MODEL_VERSION}.text.tar.gz" "data/model${LIBPINYIN_MODEL_VERSION}.text.tar.gz" || die

	eautoreconf
}

src_configure() {
	econf \
		--enable-libzhuyin \
		--disable-static
}

src_install() {
	default
	find "${D}" -name "*.la" -delete || die
}
