# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR=emake
LUA_COMPAT=( lua5-{3,4} )
PYTHON_COMPAT=( python3_{10..12} )

inherit cmake lua-single python-single-r1 toolchain-funcs

DESCRIPTION="The RPM Package Manager"
HOMEPAGE="https://rpm.org/ https://github.com/rpm-software-management/rpm"
SRC_URI="
	https://ftp.osuosl.org/pub/rpm/releases/rpm-$(ver_cut 1-2).x/${P}.tar.bz2
	http://ftp.rpm.org/releases/rpm-$(ver_cut 1-2).x/${P}.tar.bz2
"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~riscv ~s390 ~x86"
IUSE="acl audit caps +berkdb doc dbus nls openmp python readline selinux +sequoia +sqlite"
REQUIRED_USE="
	${LUA_REQUIRED_USE}
	python? ( ${PYTHON_REQUIRED_USE} )
"
# Tests run against a Fedora container image, which needs to be pulled.
RESTRICT="test"

DEPEND="
	${LUA_DEPS}
	>=app-arch/bzip2-1.0.1
	app-arch/libarchive:=
	app-arch/xz-utils
	app-arch/zstd:=
	>=app-crypt/gnupg-1.2
	>=dev-lang/perl-5.8.8
	dev-libs/elfutils
	>=dev-libs/popt-1.7
	sys-apps/file
	sys-libs/readline:=
	>=sys-libs/zlib-1.2.3-r1
	acl? ( virtual/acl )
	audit? ( sys-process/audit )
	caps? ( >=sys-libs/libcap-2.0 )
	dbus? ( sys-apps/dbus )
	nls? ( virtual/libintl )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:= )
	sequoia? ( app-crypt/rpm-sequoia )
	!sequoia? ( dev-libs/libgcrypt:= )
	sqlite? ( dev-db/sqlite:3 )
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
	nls? ( sys-devel/gettext )
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-rpm )
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.19.0-libdir.patch
	"${FILESDIR}"/${P}-musl-compat.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	lua-single_pkg_setup

	use python && python-single-r1_pkg_setup

	# bug #779769
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	# rpm no longer supports berkdb, but has readonly support.
	# https://github.com/rpm-software-management/rpm/commit/4290300e24c5ab17c615b6108f38438e31eeb1d0
	local mycmakeargs=(
		-DENABLE_TESTSUITE=OFF
		-DWITH_FAPOLICYD=OFF
		-DWITH_SELINUX=OFF
		-DENABLE_BDB_RO=$(usex berkdb)
		-DENABLE_NLS=$(usex nls)
		-DENABLE_OPENMP=$(usex openmp)
		-DENABLE_PYTHON=$(usex python)
		-DENABLE_SQLITE=$(usex sqlite)
		-DWITH_ACL=$(usex acl)
		-DWITH_AUDIT=$(usex audit)
		-DWITH_CAP=$(usex caps)
		-DWITH_DBUS=$(usex dbus)
		-DWITH_INTERNAL_OPENPGP=$(usex sequoia OFF ON)
		-DWITH_READLINE=$(usex readline)
		$(cmake_use_find_package doc Doxygen)
	)
	cmake_src_configure
}

src_test() {
	emake -C "${BUILD_DIR}" check
}

src_install() {
	cmake_src_install

	# Remove pre-built API docs.
	use doc || rm -rf "${ED}/usr/share/doc/${PF}" || die

	dodoc CREDITS README

	keepdir /usr/src/rpm/{SRPMS,SPECS,SOURCES,RPMS,BUILD}

	use python && python_optimize
}

pkg_postinst() {
	if [[ -f "${EROOT}"/var/lib/rpm/rpmdb.sqlite ]] ; then
		einfo "RPM database found... Rebuilding database (may take a while)..."
		"${EROOT}"/usr/bin/rpmdb --rebuilddb --root="${EROOT}/" || die
	else
		einfo "No RPM database found... Creating database..."
		"${EROOT}"/usr/bin/rpmdb --initdb --root="${EROOT}/" || die
	fi
}
