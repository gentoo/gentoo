# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{3,4} )
PYTHON_COMPAT=( python3_{11..14} )

inherit cmake flag-o-matic lua-single python-single-r1 toolchain-funcs

DESCRIPTION="The RPM Package Manager"
HOMEPAGE="https://rpm.org/ https://github.com/rpm-software-management/rpm"
SRC_URI="https://ftp.osuosl.org/pub/rpm/releases/rpm-$(ver_cut 1-2).x/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="acl audit bzip2 caps berkdb doc dbus iconv lzma nls openmp python
	readline selinux +sequoia +sqlite +zstd"
REQUIRED_USE="
	${LUA_REQUIRED_USE}
	python? ( ${PYTHON_REQUIRED_USE} )
"
# Tests run against a Fedora container.
RESTRICT="test"

DEPEND="
	${LUA_DEPS}
	app-alternatives/gpg
	app-arch/libarchive:=
	>=dev-lang/perl-5.8.8
	dev-libs/elfutils
	>=dev-libs/popt-1.7
	sys-apps/file
	>=virtual/zlib-1.2.3-r1:=
	acl? ( virtual/acl )
	audit? ( sys-process/audit )
	bzip2? ( >=app-arch/bzip2-1.0.1 )
	caps? ( >=sys-libs/libcap-2.0 )
	dbus? ( sys-apps/dbus )
	iconv? ( virtual/libiconv )
	lzma? ( app-arch/xz-utils )
	nls? ( virtual/libintl )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:= )
	selinux? ( sys-libs/libselinux )
	sequoia? ( >=app-crypt/rpm-sequoia-1.9.0 )
	!sequoia? ( dev-libs/libgcrypt:= )
	sqlite? ( dev-db/sqlite:3 )
	zstd? ( app-arch/zstd:= )
"
BDEPEND="
	app-text/scdoc
	virtual/pkgconfig
	doc? ( app-text/doxygen )
	nls? ( sys-devel/gettext )
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-rpm )
"

PATCHES=(
	"${FILESDIR}"/${PN}-6.0.0-musl-compat.patch
	"${FILESDIR}"/${PN}-4.20.0-libdir.patch
	"${FILESDIR}"/${PN}-6.0.0-no-hardened.patch
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

src_configure() {
	local mycmakeargs=(
		-DENABLE_NDB=ON
		-DENABLE_TESTSUITE=OFF
		-DWITH_FSVERITY=OFF
		-DWITH_IMAEVM=OFF
		-DWITH_FAPOLICYD=OFF
		-DWITH_OPENSSL=OFF
		-DWITH_LIBDW=ON
		-DWITH_LIBELF=ON
		-DENABLE_BDB_RO=$(usex berkdb)
		-DENABLE_NLS=$(usex nls)
		-DENABLE_OPENMP=$(usex openmp)
		-DENABLE_PYTHON=$(usex python)
		-DENABLE_SQLITE=$(usex sqlite)
		-DWITH_CAP=$(usex caps)
		-DWITH_ACL=$(usex acl)
		-DWITH_SELINUX=$(usex selinux)
		-DWITH_DBUS=$(usex dbus)
		-DWITH_AUDIT=$(usex audit)
		-DWITH_SEQUOIA=$(usex sequoia)
		-DWITH_READLINE=$(usex readline)
		-DWITH_BZIP2=$(usex bzip2)
		-DWITH_ICONV=$(usex iconv)
		-DWITH_ZSTD=$(usex zstd)
		-DWITH_LIBLZMA=$(usex lzma)
		-DWITH_DOXYGEN=$(usex doc)
		# Upstream expects these paths to be relative, but cmake.eclass
		# sets them as absolute paths. bug #954379
		-DCMAKE_INSTALL_INFODIR=share/info
		-DCMAKE_INSTALL_MANDIR=share/man
	)

	# special handling for ASAN
	# https://github.com/rpm-software-management/rpm/commit/ca8d1cf3f401d89ad3507aed8d7a70ad37026ca7
	if is-flagq -fsanitize=address; then
		mycmakeargs+=( -DENABLE_ASAN=ON )
	fi

	cmake_src_configure
}

src_test() {
	eninja -C "${BUILD_DIR}" check
}

src_install() {
	cmake_src_install

	dodoc CREDITS README

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
