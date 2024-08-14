# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit edo flag-o-matic multiprocessing python-single-r1 toolchain-funcs xdg

DESCRIPTION="A general purpose tile map editor"
HOMEPAGE="https://www.mapeditor.org/ https://github.com/mapeditor/tiled"
SRC_URI="https://github.com/mapeditor/tiled/archive/v${PV}/${P}.tar.gz"

LICENSE="BSD BSD-2 GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples minimal python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	app-arch/zstd:=
	dev-qt/qtbase:6[X,dbus,gui,network,opengl,widgets]
	dev-qt/qtdeclarative:6
	dev-qt/qtsvg:6
	sys-libs/zlib
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/qbs
	dev-qt/qtbase:6
	dev-qt/qttools:6[linguist]
"

QBS_PRODUCTS="tiled,csv,json"

pkg_setup() {
	if use python; then
		python-single-r1_pkg_setup
	fi
}

qbs_format_flags() {
	local -a array
	for flag in ${@}; do
		array+=( "\"${flag}\"" )
	done
	echo "[$(IFS=","; echo "${array[*]}")]"
}

src_configure() {
	if use python; then
		eapply "${FILESDIR}"/${P}-python.patch
		QBS_PRODUCTS="${QBS_PRODUCTS},python"
	fi
	if ! use minimal; then
		QBS_PRODUCTS="${QBS_PRODUCTS},defold,defoldcollection,droidcraft,flare,gmx,json1,lua,replicaisland,rpmap,tbin,tengine,terraingenerator,tmxrasterizer,tmxviewer,tscn,yy"
	fi

	edo qbs setup-qt /usr/bin/qmake6 qt6
	edo qbs config defaultProfile qt6

	local toolchain=$(tc-get-compiler-type)
	edo qbs setup-toolchains ${toolchain} ${toolchain}
	edo qbs config profiles.qt6.baseProfile ${toolchain}

	edo qbs resolve \
		--force-probe-execution \
		qbs.installPrefix:"/usr" \
		projects.Tiled.useRPaths:false \
		projects.Tiled.installHeaders:$(usex minimal false true) \
		project.libDir:$(get_libdir) \
		modules.cpp.cFlags:$(qbs_format_flags ${CFLAGS}) \
		modules.cpp.cxxFlags:$(qbs_format_flags ${CXXFLAGS}) \
		modules.cpp.linkerFlags:$(qbs_format_flags $(raw-ldflags ${LDFLAGS}))
}

src_compile() {
	edo qbs build \
		-p ${QBS_PRODUCTS} \
		-j $(get_makeopts_jobs)
}

src_install() {
	edo qbs install -p ${QBS_PRODUCTS} --install-root "${D}"

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
}
