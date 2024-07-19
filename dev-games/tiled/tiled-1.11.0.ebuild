# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs multiprocessing xdg

DESCRIPTION="A general purpose tile map editor"
HOMEPAGE="https://www.mapeditor.org/"
SRC_URI="https://github.com/mapeditor/tiled/archive/v${PV}/${P}.tar.gz"

LICENSE="BSD BSD-2 GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples wayland"

RDEPEND="
	app-arch/zstd
	dev-qt/qtbase:6[X]
	dev-qt/qtimageformats:6
	dev-qt/qtdeclarative:6
	wayland? ( dev-qt/qtwayland:6 )
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-util/qbs
"

src_configure() {
	qbs setup-qt /usr/bin/qmake6 qt6 || die
	qbs config defaultProfile qt6 || die

	if $(tc-is-clang); then
		qbs setup-toolchains clang clang || die
		qbs config profiles.qt6.baseProfile clang || die
	else
		qbs setup-toolchains gcc gcc || die
		qbs config profiles.qt6.baseProfile gcc || die
	fi
}

qbs_format_flags() {
	local result="["

	for flag in $@; do
		if [[ ${result} != "[" ]]; then
			result="${result},"
		fi
		result="${result}\"${flag}\""
	done

	result="${result}]"
	echo ${result}
}

src_compile() {
	set -o noglob
	local QBS_CFLAGS=$(qbs_format_flags ${CFLAGS})
	local QBS_CXXFLAGS=$(qbs_format_flags ${CXXFLAGS})
	set +o noglob

	qbs build \
		qbs.installPrefix:"/usr" \
		projects.Tiled.installHeaders:true \
		project.libDir:$(get_libdir) \
		modules.cpp.cFlags:${QBS_CFLAGS} \
		modules.cpp.cxxFlags:${QBS_CXXFLAGS} \
		-j $(get_makeopts_jobs) \
		|| die
}

src_install() {
	qbs install --install-root "${D}" || die

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
