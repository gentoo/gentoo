# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_TAG=7aedd5675883d4412cf20917d340b6985e3ecb842e88a39f135df034b2d5f4d3

DESCRIPTION="Simple, high-reliability, source control management, and more"
HOMEPAGE="https://www.fossil-scm.org/"
SRC_URI="https://fossil-scm.org/home/tarball/${MY_TAG}/fossil-src-${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 ~x86"
IUSE="debug fusefs json miniz system-sqlite +ssl static tcl tcl-stubs
	  tcl-private-stubs th1-docs th1-hooks"

REQUIRED_USE="ssl? ( !miniz )"

RDEPEND="
	sys-libs/zlib
	|| (
		sys-libs/readline:0
		dev-libs/libedit
	)
	system-sqlite? ( >=dev-db/sqlite-3.35.0:3 )
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

# Tests can't be run from the build directory
RESTRICT="test"

# fossil-2.10-check-lib64-for-tcl.patch: Bug 690828
PATCHES=( "${FILESDIR}"/fossil-2.10-check-lib64-for-tcl.patch )

S="${WORKDIR}/fossil-src-${PV}"

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
	useflags=( miniz tcl-stubs tcl-private-stubs th1-docs th1-hooks )
	for u in ${useflags[@]} ; do
		use ${u} &&  myconf+=" --with-${u}"
	done

	tc-export CC CXX
	CC_FOR_BUILD=${CC} ./configure ${myconf} || die
}

src_install() {
	dobin fossil
}
