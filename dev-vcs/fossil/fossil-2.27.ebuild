# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_TAG="99675884a93c09125dbfbef0ca47959626c81545c132e247e67a08bd12ac7256"

DESCRIPTION="Simple, high-reliability, source control management, and more"
HOMEPAGE="https://www.fossil-scm.org/home"

SRC_URI="https://fossil-scm.org/home/tarball/${MY_TAG}/fossil-src-${PV}.tar.gz"

S="${WORKDIR}/fossil-src-${PV}"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="debug fusefs json system-sqlite +ssl static tcl tcl-stubs
	  tcl-private-stubs test th1-docs th1-hooks"

# These tests are currently failing:
#   settings-valid-local-anon-cookie-lifespan
#   settings-valid-local-regexp-limit
#   settings-valid-local-robot-exception
#   settings-valid-global-anon-cookie-lifespan
#   settings-valid-global-regexp-limit
#   settings-valid-global-robot-exception
#
# They can be ignored[1] and should be removed with 2.28.
#
# [1]: https://fossil-scm.org/forum/forumpost/8ffbc6631bb043f1
RESTRICT="test"

# Please check sqlite minimum version on every release. This can be done with:
#     ./configure --print-minimum-sqlite-version
RDEPEND="
	virtual/zlib:=
	|| (
		sys-libs/readline:0
		dev-libs/libedit
	)
	system-sqlite? ( >=dev-db/sqlite-3.49.0:3 )
	ssl? ( dev-libs/openssl:0= )
	tcl? ( dev-lang/tcl:0= )
"

# Either tcl or jimtcl need to be present to build Fossil (Bug #675778)
DEPEND="${RDEPEND}
	static? (
		virtual/zlib[static-libs]
		ssl? ( dev-libs/openssl[static-libs] )
		system-sqlite? ( dev-db/sqlite[static-libs] )
	)
	!tcl? (
		|| (
			dev-lang/tcl:*
			dev-lang/jimtcl:*
		)
	)
"

BDEPEND="
	test? (
		dev-lang/tcl
		tcl? ( dev-db/sqlite[tcl] )
		!riscv? ( json? ( dev-tcltk/tcllib ) )
	)
"

PATCHES=(
	# fossil-2.10-check-lib64-for-tcl.patch: Bug 690828
	"${FILESDIR}"/fossil-2.10-check-lib64-for-tcl.patch
	"${FILESDIR}"/fossil-2.27-fix-json-test-content-length.patch
)

src_configure() {
	# this is not an autotools situation so don't make it seem like one
	# --with-tcl: works
	# --without-tcl: dies
	local myconf
	myconf=(--with-openssl="$(usex ssl auto none)")
	use debug         && myconf+=(--fossil-debug)
	use json          && myconf+=(--json)
	use system-sqlite && myconf+=(--disable-internal-sqlite)
	use static        && myconf+=(--static)
	use tcl           && myconf+=(--with-tcl=1)
	use fusefs        || myconf+=(--disable-fusefs)

	local u useflags
	useflags=( tcl-stubs tcl-private-stubs th1-docs th1-hooks )
	for u in "${useflags[@]}" ; do
		use "${u}" &&  myconf+=(--with-"${u}")
	done

	tc-export CC CXX
	CC_FOR_BUILD=${CC} ./configure "${myconf[@]}" || die
}

src_install() {
	dobin fossil
	doman fossil.1
}
