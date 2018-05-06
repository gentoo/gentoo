# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eapi7-ver

DESCRIPTION="Qt SQL driver plugin for SQLCipher"
HOMEPAGE="https://github.com/blizzard4591/qt5-sqlcipher"
SRC_URI="https://github.com/blizzard4591/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1" # version 2.1 only
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-db/sqlcipher-3.4.1
	>=dev-qt/qtcore-5.7.1:5=
	>=dev-qt/qtsql-5.7.1:5=[sqlite]	<dev-qt/qtsql-5.10:5=[sqlite]"
RDEPEND="${DEPEND}"

DOCS=(README.md)

src_prepare() {
	eapply "${FILESDIR}"/${PN}-install-path.patch
	sed -i -e "s/@LIBDIR@/$(get_libdir)/" CMakeLists.txt || die

	local v=$(best_version dev-qt/qtsql:5)
	v=$(ver_cut 1-3 ${v#*/qtsql-})
	[[ -n ${v} ]] || die "could not determine qtsql version"
	if ! [[ -d qt-file-cache/${v} ]]; then
		local vc
		case $(ver_cut 1-2 ${v}) in
			5.7) vc=5.7.1 ;;
			5.9) vc=5.9.3 ;;
			*) die "qtsql-${v} not supported" ;;
		esac
		elog "qtsql-${v} not in cache, using ${vc} instead"
		cp -R qt-file-cache/${vc} qt-file-cache/${v} || die
	fi

	cmake-utils_src_prepare
}

src_test() {
	cd "${BUILD_DIR}" || die
	./qsqlcipher-test || die
}
