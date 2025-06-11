# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# All tests currently timeout even with a large timeout multiliplier
# so they are commented out and disabled for now

EAPI=8

inherit meson xdg

DESCRIPTION="Application to create and manage beer recipes"
HOMEPAGE="https://www.brewtarget.beer/"
SRC_URI="https://github.com/Brewtarget/brewtarget/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-cpp/valijson
	dev-qt/qttools:6[linguist]
	virtual/pandoc
"
DEPEND="
	dev-libs/boost:=[stacktrace]
	dev-libs/openssl:=
	dev-libs/xalan-c
	dev-libs/xerces-c:=
	dev-qt/qtbase:6[gui,network,sql,sqlite,widgets,xml]
	dev-qt/qtmultimedia:6
	dev-qt/qtsvg:6
"
RDEPEND="${DEPEND}"

PATCHES=(
	# This patch must come first. The next patch requires it.
	"${FILESDIR}/${PN}-4.0.17-no-boost-libbacktrace.patch"
	"${FILESDIR}/${PN}-4.0.17-unbundle-valijson.patch"
	"${FILESDIR}/${PN}-4.0.17-find-lupdate.patch"
	"${FILESDIR}/${PN}-4.0.17-fix-docdir.patch"
	# These 2 patches must come last
	# sed -i -e "/^[^#]/ s/static : true/static : false/g" meson.build
	"${FILESDIR}/${PN}-4.0.17-silence-compiler-noise.patch"
	# sed -i -e "s/if compiler.get_id() == 'gcc'/if false/" meson.build
	"${FILESDIR}/${PN}-4.0.17-dont-touch-CFLAGS.patch"
)

src_test() {
	local -x QT_QPA_PLATFORM=offscreen

	meson_src_test
}

src_install() {
	meson_src_install
	# Upstream issue: https://github.com/Brewtarget/brewtarget/issues/933
	mv "${ED}"/usr/share/applications/{${PN},com.brewken.${PN}}.desktop || die
}
