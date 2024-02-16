# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# All tests currently timeout even with a large timeout multiliplier
# so they are commented out and disabled for now

EAPI=8

PLOCALES="ast ca cs da de el en en_GB es et eu fr gl hr hu it ja lv nb nl pl pt pt_BR pt_PT ru sr sv tr zh"
#inherit meson plocale xdg-utils virtualx
inherit meson plocale xdg-utils

DESCRIPTION="Application to create and manage beer recipes"
HOMEPAGE="https://www.brewtarget.beer/"
SRC_URI="https://github.com/Brewtarget/brewtarget/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"

#RESTRICT="!test? ( test )"
RESTRICT="test"

BDEPEND="
	dev-cpp/valijson
	dev-qt/qttools:6[linguist]
	virtual/pandoc
"
DEPEND="
	dev-libs/boost[stacktrace]
	dev-libs/openssl:=
	dev-libs/xalan-c
	dev-libs/xerces-c
	dev-qt/qtbase:6[gui,network,sql,sqlite,widgets,xml]
	dev-qt/qtmultimedia:6
	dev-qt/qtsvg:6
"
RDEPEND="${DEPEND}"

PATCHES=(
	# This patch must come first. The next patch requires it.
	"${FILESDIR}/${PN}-4.0.9-unbundle-valijson.patch"
	"${FILESDIR}/${PN}-4.0.9-no-boost-libbacktrace.patch"
	"${FILESDIR}/${PN}-4.0.9-find-lupdate.patch"
	"${FILESDIR}/${PN}-4.0.9-fix-docdir.patch"
	)

remove_locale() {
	sed -i -e "/bt_${1}\.ts/d" meson.build || die
}

src_prepare() {
	default
	# Silence some noise
	sed -i -e "s/static : true/static : false/g" meson.build || die
	# Leave CFLAGS alone
	sed -i -e "s/if compiler.get_id() == 'gcc'/if false/" meson.build || die
	plocale_find_changes translations bt_ .ts
	plocale_for_each_disabled_locale remove_locale
}

#my_test() {
#	meson_src_test
#	return $?
#}

#s#rc_test() {
#	virtx my_test
#}

pkg_postinst()
{
	xdg_icon_cache_update
}

pkg_postrm()
{
	xdg_icon_cache_update
}
