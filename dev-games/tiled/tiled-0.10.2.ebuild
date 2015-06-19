# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/tiled/tiled-0.10.2.ebuild,v 1.1 2014/10/27 15:58:28 kensington Exp $

EAPI=5

PLOCALES="cs de en es fr he it ja lv nl pt pt_BR ru zh zh_TW"
PYTHON_COMPAT=( python2_7 )
inherit multilib l10n python-single-r1 qt4-r2

DESCRIPTION="A general purpose tile map editor"
HOMEPAGE="http://www.mapeditor.org/"
SRC_URI="https://github.com/bjorn/tiled/archive/v${PV}/${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND=">=dev-qt/qtcore-4.7:4
	>=dev-qt/qtgui-4.7:4
	>=dev-qt/qtopengl-4.7:4
	sys-libs/zlib
	python? ( ${PYTHON_DEPS} )"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS COPYING NEWS README.md )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	rm -r src/zlib || die
	sed -e "s/^LANGUAGES =.*/LANGUAGES = $(l10n_get_locales)/" \
		-i translations/translations.pro || die
}

src_configure() {
	eqmake4 LIBDIR="/usr/$(get_libdir)" PREFIX="/usr" DISABLE_PYTHON_PLUGIN="$(usex !python)"
}

src_install() {
	qt4-r2_src_install

	if use examples ; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
}
