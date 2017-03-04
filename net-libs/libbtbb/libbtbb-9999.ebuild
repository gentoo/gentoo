# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL=1

inherit multilib cmake-utils python-single-r1

DESCRIPTION="A library to decode Bluetooth baseband packets"
HOMEPAGE="http://libbtbb.sourceforge.net/"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/greatscottgadgets/libbtbb.git"
	inherit git-r3
	KEYWORDS=""
else
	MY_PV=${PV/\./-}
	MY_PV=${MY_PV/./-R}
	S=${WORKDIR}/${PN}-${MY_PV}
	SRC_URI="https://github.com/greatscottgadgets/${PN}/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-2"
SLOT="0/${PV}"
IUSE="extras static-libs wireshark-plugins"

RDEPEND="extras? ( ${PYTHON_DEPS} )
	wireshark-plugins? (
		>=net-analyzer/wireshark-1.8.3-r1:=
	)
"
DEPEND="${RDEPEND}
	wireshark-plugins? ( dev-libs/glib
			virtual/pkgconfig )"

REQUIRED_USE="extras? ( ${PYTHON_REQUIRED_USE} )"

get_PV() { local pv=$(best_version $1); pv=${pv#$1-}; pv=${pv%-r*}; pv=${pv//_}; echo ${pv}; }

which_plugins() {
	if has_version '>=net-analyzer/wireshark-2.2.0'; then
		plugins=""
	elif has_version '>=net-analyzer/wireshark-1.12.0'; then
		plugins="btbb btbredr"
	elif has_version '<net-analyzer/wireshark-1.12.0'; then
		plugins="btbb btle btsm"
	fi
}

src_prepare(){
	CMAKE_USE_DIR="${S}"
	BUILD_DIR="${S}"_build
	cmake-utils_src_prepare

	if use wireshark-plugins; then
		which_plugins
		for i in ${plugins}
		do
			sed -i 's#column_info#packet#' wireshark/plugins/${i}/cmake/FindWireshark.cmake || die
			if has_version '>=net-analyzer/wireshark-2.0';  then
				CMAKE_USE_DIR="${S}"/wireshark/plugins/${i}
			else
				CMAKE_USE_DIR="${S}"/wireshark/plugins-legacy/${i}
			fi
			BUILD_DIR="${WORKDIR}"/${i}_build
			cmake-utils_src_prepare
		done
	fi
}

src_configure() {
	CMAKE_USE_DIR="${S}"
	BUILD_DIR="${S}"_build
	local mycmakeargs=(
		-DENABLE_PYTHON=$(usex extras)
		-DBUILD_STATIC_LIB=$(usex static-libs)
		-DBUILD_ROOT="${ED}"
	)
	cmake-utils_src_configure

	if use wireshark-plugins; then
		for i in ${plugins}
		do
			if has_version '>=net-analyzer/wireshark-2.0';  then
				CMAKE_USE_DIR="${S}"/wireshark/plugins/${i}
			else
				CMAKE_USE_DIR="${S}"/wireshark/plugins-legacy/${i}
			fi
			BUILD_DIR="${WORKDIR}"/${i}_build
			local mycmakeargs=(
			-DCMAKE_INSTALL_LIBDIR="/usr/$(get_libdir)/wireshark/plugins/$(get_PV net-analyzer/wireshark)"
			)
			cmake-utils_src_configure
		done
	fi
}

src_compile(){
	CMAKE_USE_DIR="${S}"
	BUILD_DIR="${S}"_build
	cmake-utils_src_compile

	if use wireshark-plugins; then
		for i in ${plugins}
		do
			if has_version '>=net-analyzer/wireshark-2.0';  then
				CMAKE_USE_DIR="${S}"/wireshark/plugins/${i}
			else
				CMAKE_USE_DIR="${S}"/wireshark/plugins-legacy/${i}
			fi
			BUILD_DIR="${WORKDIR}"/${i}_build
			cmake-utils_src_compile
		done
	fi
}

src_test(){
	CMAKE_USE_DIR="${S}"
	BUILD_DIR="${S}"_build
	cmake-utils_src_test

	if use wireshark-plugins; then
		for i in ${plugins}
		do
			if has_version '>=net-analyzer/wireshark-2.0';  then
				CMAKE_USE_DIR="${S}"/wireshark/plugins/${i}
			else
				CMAKE_USE_DIR="${S}"/wireshark/plugins-legacy/${i}
			fi
			BUILD_DIR="${WORKDIR}"/${i}_build
			cmake-utils_src_test
		done
	fi
}

src_install(){
	CMAKE_USE_DIR="${S}"
	BUILD_DIR="${S}"_build
	cmake-utils_src_install

	if use wireshark-plugins; then
		for i in ${plugins}
		do
			if has_version '>=net-analyzer/wireshark-2.0';  then
				CMAKE_USE_DIR="${S}"/wireshark/plugins/${i}
			else
				CMAKE_USE_DIR="${S}"/wireshark/plugins-legacy/${i}
			fi
			BUILD_DIR="${WORKDIR}"/${i}_build
			cmake-utils_src_install
		done
	fi
}
