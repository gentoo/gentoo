# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KMNAME="kdepim"
KMMODULE="kresources"
QT3SUPPORT_REQUIRED="true"
inherit kde4-meta

DESCRIPTION="KDE PIM groupware plugin collection (noakonadi branch)"
HOMEPAGE="https://launchpad.net/~pali/+archive/ubuntu/kdepim-noakonadi"

IUSE="debug"
KEYWORDS="~amd64 ~x86"

DEPEND="
	$(add_kdeapps_dep kaddressbook)
	$(add_kdeapps_dep kdepimlibs)
	$(add_kdeapps_dep libkdepim)
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-gcc-6.3.patch" )

KMEXTRACTONLY="
	kaddressbook/common/
	kmail/
	knotes/
	korganizer/version.h
"

KMLOADLIBS="libkdepim"

src_prepare() {
	local kconfig_compiler="${EPREFIX}/usr/bin/kconfig_compiler"

	pushd kaddressbook/common > /dev/null
	# create the kabprefs_base.h file
	"${kconfig_compiler}" kaddressbook.kcfg kabprefs_base.kcfgc
	popd > /dev/null

	kde4-meta_src_prepare
}

src_install() {
	kde4-meta_src_install

	# Install headers needed by kdepim-wizards, egroupware stuff gone
	insinto /usr/include/${PN}
	doins "${CMAKE_BUILD_DIR}"/${KMMODULE}/{groupwise,slox}/*.h
}
