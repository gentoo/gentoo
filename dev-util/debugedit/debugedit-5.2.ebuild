# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multiprocessing verify-sig toolchain-funcs

DESCRIPTION="Create debuginfo and source file distributions"
HOMEPAGE="https://sourceware.org/debugedit/"
SRC_URI="
	https://sourceware.org/ftp/debugedit/${PV}/${P}.tar.xz
	verify-sig? ( https://sourceware.org/ftp/debugedit/${PV}/${P}.tar.xz.sig )
"

LICENSE="GPL-3+ GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/elfutils-0.176-r1:=
	>=dev-libs/xxhash-0.8:=
	elibc_musl? ( >=sys-libs/error-standalone-2.0 )
"
RDEPEND="
	${DEPEND}
	sys-devel/dwz
"
BDEPEND="
	sys-apps/help2man
	virtual/pkgconfig
	test? (
		app-alternatives/cpio
	)
	verify-sig? (
		sec-keys/openpgp-keys-debugedit
	)
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/debugedit.gpg

PATCHES=(
	"${FILESDIR}"/${P}-bashism.patch
	"${FILESDIR}"/${P}-buildid.patch
)

src_configure() {
	tc-export PKG_CONFIG

	if use elibc_musl; then
		export CFLAGS="${CFLAGS} $(${PKG_CONFIG} --cflags error-standalone)"
		export LIBS="${LIBS} $(${PKG_CONFIG} --libs error-standalone)"
	fi

	local myconf=(
		# avoid BDEP on dwz
		DWZ=dwz
		ac_cv_dwz_j=yes

		# We don't want to effectively bundle xxhash. It fails to
		# build with -Og and such too (bug #956627).
		--disable-inlined-xxhash
	)
	econf "${myconf[@]}"
}

src_test() {
	local -x CCACHE_DISABLE=1
	emake -Onone check TESTSUITEFLAGS="--jobs=$(get_makeopts_jobs)"
}
