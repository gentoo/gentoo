# Copyright 2011-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=(python{3_6,3_7,3_8,3_9})

inherit python-any-r1 scons-utils toolchain-funcs

MY_PN="sunpinyin"
MY_P="${MY_PN}-${PV}"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/sunpinyin/sunpinyin"
elif [[ "${PV}" == *_pre* ]]; then
	SUNPINYIN_GIT_REVISION="f39c195db08661e894017507842991a1ef70bedf"
fi

DESCRIPTION="Standalone XIM server for SunPinyin"
HOMEPAGE="https://github.com/sunpinyin/sunpinyin"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
elif [[ "${PV}" == *_pre* ]]; then
	SRC_URI="https://github.com/sunpinyin/${MY_PN}/archive/${SUNPINYIN_GIT_REVISION}.tar.gz -> ${MY_P}.tar.gz"
else
	SRC_URI="https://github.com/sunpinyin/${MY_PN}/archive/v${PV/_/-}.tar.gz -> ${MY_P}.tar.gz"
fi

LICENSE="|| ( CDDL LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="virtual/pkgconfig"
DEPEND="~app-i18n/sunpinyin-${PV}
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/pango"
RDEPEND="${DEPEND}
	app-i18n/sunpinyin-data"

if [[ "${PV}" == *_pre* ]]; then
	S="${WORKDIR}/${MY_PN}-${SUNPINYIN_GIT_REVISION}"
elif [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/${MY_PN}-${PV/_/-}"
fi

src_prepare() {
	default

	# https://github.com/sunpinyin/sunpinyin/pull/101
	sed -e "/^[[:space:]]*print /s/print \(.*\)/print(\1)/" -i wrapper/xim/SConstruct || die

	# https://github.com/sunpinyin/sunpinyin/issues/110
	sed -e "s/^\( *\)('CXX', 'CXX'),/&\n\1('AR', 'AR'),\n\1('RANLIB', 'RANLIB'),/" -i wrapper/xim/SConstruct || die

	# https://github.com/sunpinyin/sunpinyin/issues/114
	sed -e "/^#include <iconv\.h>$/d" -i wrapper/xim/xim.c || die
}

src_configure() {
	tc-export AR CC CXX RANLIB
}

src_compile() {
	escons -C wrapper/xim \
		--prefix="${EPREFIX}/usr"
}

src_install() {
	escons -C wrapper/xim --install-sandbox="${D}" install
}
