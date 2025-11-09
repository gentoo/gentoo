# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Qt SQL driver plugin for SQLCipher"
HOMEPAGE="https://github.com/blizzard4591/qt5-sqlcipher"
SRC_URI="https://github.com/blizzard4591/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1" # version 2.1 only
SLOT="6"
KEYWORDS="~amd64"

RDEPEND=">=dev-db/sqlcipher-4.6.1
	>=dev-qt/qtbase-6.9.3:6=[sql,sqlite] <dev-qt/qtbase-6.11:6=[sql,sqlite]"
DEPEND="${RDEPEND}"

DOCS=(README.md)

src_prepare() {
	eapply "${FILESDIR}"/${P}-install-path.patch
	sed -i -e "s:@LIBDIR@:$(get_libdir):" CMakeLists.txt || die

	local v=$(best_version dev-qt/qtbase:6)
	v=$(ver_cut 1-3 ${v#*/qtbase-})
	[[ -n ${v} ]] || die "could not determine qtbase version"
	if ! [[ -d qt-file-cache/${v} ]]; then
		local vc
		case $(ver_cut 1-2 ${v}) in
			6.9) vc=6.9.3 ;;
			6.10) vc=6.10.0 ;;
			*) die "qtbase-${v} not supported" ;;
		esac
		elog "qtbase-${v} not in cache, using ${vc} instead"
		cp -R qt-file-cache/${vc} qt-file-cache/${v} || die
	fi

	cmake_src_prepare
}

src_test() {
	cd "${BUILD_DIR}" || die
	./qsqlcipher-test || die
}
