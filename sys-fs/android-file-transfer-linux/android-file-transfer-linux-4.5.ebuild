# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit cmake python-single-r1 xdg

DESCRIPTION="Android File Transfer for Linux"
HOMEPAGE="https://github.com/whoozle/android-file-transfer-linux"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/whoozle/android-file-transfer-linux.git"
else
	SRC_URI="https://github.com/whoozle/android-file-transfer-linux/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="fuse gui python taglib zune"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	sys-apps/file
	sys-libs/readline:0=
	fuse? ( sys-fs/fuse:3= )
	gui? ( dev-qt/qtbase:6[gui,network,widgets] )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pybind11[${PYTHON_USEDEP}]
		')
	)
	taglib? ( media-libs/taglib:= )
	zune? ( dev-libs/openssl:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	gui? ( dev-qt/qttools:6[linguist] )
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_FUSE="$(usex fuse)"
		-DBUILD_MTPZ="$(usex zune)"
		-DBUILD_PYTHON="$(usex python)"
		-DBUILD_QT_UI="$(usex gui)"
		-DBUILD_SHARED_LIB="ON"
		-DBUILD_TAGLIB="$(usex taglib)"
		# Upstream recommends to keep this off as libusb is broken
		-DUSB_BACKEND_LIBUSB="OFF"
	)

	# prevent using of last version
	use python && mycmakeargs+=( -DPython_EXECUTABLE="${PYTHON}" )

	cmake_src_configure
}
