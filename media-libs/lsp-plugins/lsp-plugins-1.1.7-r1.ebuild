# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Linux Studio Plugins"
HOMEPAGE="https://lsp-plug.in"

if [[ ${PV} == *9999 ]];then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/sadko4u/lsp-plugins"
	EGIT_BRANCH="devel"
else
	SRC_URI="https://github.com/sadko4u/lsp-plugins/archive/${P}.tar.gz"
	S="${WORKDIR}/${PN}-${P}"
	KEYWORDS="amd64 x86"
fi

LICENSE="LGPL-3"
SLOT="0"
IUSE="doc jack ladspa +lv2"
REQUIRED_USE="|| ( jack ladspa lv2 )"

DEPEND="
	dev-libs/expat
	media-libs/libsndfile
	doc? ( dev-lang/php:* )
	jack? (
		virtual/jack
		x11-libs/cairo[X]
	)
	ladspa? ( media-libs/ladspa-sdk )
	lv2? (
		media-libs/lv2
		x11-libs/cairo[X]
	)
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile(){
	use doc && MODULES+="doc"
	use jack && MODULES+=" jack"
	use ladspa && MODULES+=" ladspa"
	use lv2 && MODULES+=" lv2"
	emake BUILD_MODULES="${MODULES}"
}

src_install(){
	emake PREFIX="/usr" DESTDIR="${ED}" LIB_PATH="/usr/$(get_libdir)" install
}
