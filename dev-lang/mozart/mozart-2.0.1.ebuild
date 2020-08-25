# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils java-pkg-2 java-ant-2

PATCHSET_VER="1"

DESCRIPTION="Advanced development platform for intelligent, distributed applications"
HOMEPAGE="http://mozart2.org/"
SRC_URI="https://github.com/mozart/mozart2/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~keri/distfiles/mozart/${P}-gentoo-patchset-${PATCHSET_VER}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="emacs test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/boost:=
	dev-libs/gmp:0
	dev-lang/tcl:0
	dev-lang/tk:0
	emacs? ( >=app-editors/emacs-23.1:* )"

DEPEND="${RDEPEND}
	dev-java/ant-core
	>=virtual/jdk-1.8:=
	dev-lang/scala:2.12
	test? ( dev-cpp/gtest:= )"

S="${WORKDIR}/${PN}2-${PV}"
BUILD_DIR="${S}/build"
CMAKE_USE_DIR="${S}"

src_prepare() {
	if [[ -d "${WORKDIR}"/${PV} ]] ; then
		eapply "${WORKDIR}"/${PV}
	fi
	eapply_user

	touch "${S}"/stdlib/CMakeLists.txt
	touch "${S}"/vm/vm/test/gtest/CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DMOZART_BOOST_USE_STATIC_LIBS=OFF
		-DEMACS=$(if use emacs; then echo /usr/bin/emacs; fi)
		)

	cmake-utils_src_configure
}

src_compile() {
	EANT_GENTOO_CLASSPATH="scala:2.12"
	cd "${S}"/bootcompiler
	ANT_OPTS="-Xss2M" eant jar

	cd "${S}"
	cmake-utils_src_compile
}

src_test() {
	cmake-utils_src_compile vmtest platform-test
	cmake-utils_src_test -V
}

src_install() {
	cmake-utils_src_install

	cd "${BUILD_DIR}"
	dolib.so vm/vm/main/libmozartvm.so
	dolib.so vm/boostenv/main/libmozartvmboost.so
}

pkg_postinst() {
	if use emacs; then
		xdg_icon_cache_update
		xdg_desktop_database_update
	fi
}

pkg_postrm() {
	if use emacs; then
		xdg_icon_cache_update
		xdg_desktop_database_update
	fi
}
