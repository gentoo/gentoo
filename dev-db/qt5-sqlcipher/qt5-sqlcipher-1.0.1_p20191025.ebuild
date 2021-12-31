# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

COMMIT="8b8ba1579f4fdd0d2c1e8bd9596eedf5101dd917"
DESCRIPTION="Qt SQL driver plugin for SQLCipher"
HOMEPAGE="https://github.com/blizzard4591/qt5-sqlcipher"
SRC_URI="https://github.com/blizzard4591/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1" # version 2.1 only
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-db/sqlcipher-3.4.1
	>=dev-qt/qtcore-5.12.3:5=
	>=dev-qt/qtsql-5.12.3:5=[sqlite] <dev-qt/qtsql-5.14:5=[sqlite]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${COMMIT}"
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
			5.12) vc=5.12.5 ;;
			5.13) vc=5.13.1 ;;
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
