# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit cmake python-single-r1 xdg

DESCRIPTION="Android File Transfer for Linux"
HOMEPAGE="https://github.com/whoozle/android-file-transfer-linux"

if [[ "${PV}" = *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/whoozle/android-file-transfer-linux.git"
else
	SRC_URI="https://github.com/whoozle/android-file-transfer-linux/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"

IUSE="fuse python qt5 taglib zune"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	sys-apps/file
	sys-libs/readline:0=
	fuse? ( sys-fs/fuse:0 )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pybind11[${PYTHON_USEDEP}]
		')
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
	)
	taglib? ( media-libs/taglib )
	zune? (
		dev-libs/openssl:0=
	)
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	qt5? ( dev-qt/linguist-tools:5 )
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

# required to override src_prepare from xdg eclass
src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_FUSE="$(usex fuse)"
		-DBUILD_MTPZ="$(usex zune)"
		-DBUILD_PYTHON="$(usex python)"
		-DBUILD_QT_UI="$(usex qt5)"
		-DBUILD_SHARED_LIB="ON"
		-DBUILD_TAGLIB="$(usex taglib)"
		# Upstream recommends to keep this off as libusb is broken
		-DUSB_BACKEND_LIBUSB="OFF"
		$(usex qt5 '-DDESIRED_QT_VERSION=5' '')
	)
	cmake_src_configure
}
