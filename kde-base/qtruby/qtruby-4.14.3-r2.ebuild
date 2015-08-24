# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OPENGL_REQUIRED="always"
DECLARATIVE_REQUIRED="optional"
KDE_REQUIRED="never"
USE_RUBY="ruby20"
# Only one ruby version is supported:
# 1) cmake bails when configuring twice or more - solved with CMAKE_IN_SOURCE_BUILD=1
# 2) the ebuild can only be installed for one ruby variant, otherwise the compiled
#    files with identical path+name will overwrite each other - difficult :(

inherit kde4-base ruby-ng

DESCRIPTION="Qt Ruby bindings"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug phonon qscintilla qwt webkit"
HOMEPAGE="https://techbase.kde.org/Development/Languages/Ruby"

DEPEND="
	$(add_kdebase_dep smokeqt 'declarative?,opengl,phonon?,qscintilla?,qwt?,webkit?')
"

RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-ruby20.patch" )

pkg_setup() {
	ruby-ng_pkg_setup
	kde4-base_pkg_setup
}

src_unpack() {
	local S="${WORKDIR}/${P}"
	kde4-base_src_unpack

	cd "${WORKDIR}"
	mkdir all
	mv ${P} all/ || die "Could not move sources"
}

all_ruby_prepare() {
	kde4-base_src_prepare
}

each_ruby_configure() {
	local CMAKE_USE_DIR=${S}
	local mycmakeargs=(
		-DRUBY_LIBRARY=$(ruby_get_libruby)
		-DRUBY_INCLUDE_PATH=$(ruby_get_hdrdir)
		-DRUBY_EXECUTABLE=${RUBY}
		$(cmake-utils_use_disable declarative QtDeclarative)
		$(cmake-utils_use_with phonon)
		$(cmake-utils_use_with qscintilla QScintilla)
		$(cmake-utils_use_with qwt Qwt5)
		$(cmake-utils_use_disable webkit QtWebKit)
	)
	kde4-base_src_configure
}

each_ruby_compile() {
	local CMAKE_USE_DIR=${S}
	kde4-base_src_compile
}

each_ruby_install() {
	local CMAKE_USE_DIR=${S}
	kde4-base_src_install
}
