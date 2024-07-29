# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_TAG="8be0372c1051043761320c8ea8669c3cf320c406e5fe18ad36b7be5f844ca73b"

DESCRIPTION="Simple, high-reliability, source control management, and more"
HOMEPAGE="https://www.fossil-scm.org/home"

# Arrow can be dropped with next version. Needed to resolve
# https://bugs.gentoo.org/931862
SRC_URI="https://fossil-scm.org/home/tarball/${MY_TAG}/fossil-src-${PV}.tar.gz -> fossil-src-${PV}-r1.tar.gz"

S="${WORKDIR}/fossil-src-${PV}"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~riscv ~x86"
IUSE="debug fusefs json system-sqlite +ssl static tcl tcl-stubs
	  tcl-private-stubs test th1-docs th1-hooks"
RESTRICT="!test? ( test )"

# Please check sqlite minimum version on every release. This can be done with:
#     ./configure --print-minimum-sqlite-version
RDEPEND="
	sys-libs/zlib
	|| (
		sys-libs/readline:0
		dev-libs/libedit
	)
	system-sqlite? ( >=dev-db/sqlite-3.38.0:3 )
	ssl? ( dev-libs/openssl:0= )
	tcl? ( dev-lang/tcl:0= )
"

# Either tcl or jimtcl need to be present to build Fossil (Bug #675778)
DEPEND="${RDEPEND}
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
		!riscv? ( json? ( dev-tcltk/tcllib ) )
	)
"

PATCHES=(
	# fossil-2.10-check-lib64-for-tcl.patch: Bug 690828
	"${FILESDIR}"/fossil-2.10-check-lib64-for-tcl.patch
)

src_prepare() {
	eapply -p0 -- \
		   "${FILESDIR}"/fossil-2.24-test-fixes.patch \
		   "${FILESDIR}"/fossil-2.24-disable-utf8-tests-1179-1586-1587.patch \
		   "${FILESDIR}"/fossil-2.24-fix-json-test-content-length.patch

	default
}

src_configure() {
	# this is not an autotools situation so don't make it seem like one
	# --with-tcl: works
	# --without-tcl: dies
	local myconf="--with-openssl=$(usex ssl auto none)"
	use debug         && myconf+=' --fossil-debug'
	use json          && myconf+=' --json'
	use system-sqlite && myconf+=' --disable-internal-sqlite'
	use static        && myconf+=' --static'
	use tcl           && myconf+=' --with-tcl=1'
	use fusefs        || myconf+=' --disable-fusefs'

	local u useflags
	useflags=( tcl-stubs tcl-private-stubs th1-docs th1-hooks )
	for u in ${useflags[@]} ; do
		use ${u} &&  myconf+=" --with-${u}"
	done

	tc-export CC CXX
	CC_FOR_BUILD=${CC} ./configure ${myconf} || die
}

src_install() {
	dobin fossil
	doman fossil.1
}
