# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake java-pkg-2 java-ant-2

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

src_prepare() {
	if [[ -d "${WORKDIR}"/${PV} ]] ; then
		eapply "${WORKDIR}"/${PV}
	fi

	touch stdlib/CMakeLists.txt || die
	touch vm/vm/test/gtest/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DMOZART_BOOST_USE_STATIC_LIBS=OFF
		-DEMACS=$(usex emacs "/usr/bin/emacs" "")
	)

	cmake_src_configure
}

src_compile() {
	EANT_GENTOO_CLASSPATH="scala:2.12"
	pushd bootcompiler > /dev/null || die
	ANT_OPTS="-Xss2M" eant jar
	popd > /dev/null || die

	cmake_src_compile
}

src_test() {
	cmake_build vmtest platform-test
	cmake_src_test -V
}

src_install() {
	cmake_src_install

	dolib.so "${BUILD_DIR}"/vm/vm/main/libmozartvm.so
	dolib.so "${BUILD_DIR}"/vm/boostenv/main/libmozartvmboost.so
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
