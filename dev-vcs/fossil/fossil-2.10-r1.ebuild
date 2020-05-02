# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Simple, high-reliability, source control management, and more"
HOMEPAGE="https://www.fossil-scm.org/"
SRC_URI="https://fossil-scm.org/home/uv/fossil-src-${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="debug fusefs json -legacy-mv-rm -miniz system-sqlite +ssl static
	  tcl tcl-stubs tcl-private-stubs th1-docs th1-hooks"

REQUIRED_USE="ssl? ( !miniz )"

RDEPEND="
	sys-libs/zlib
	|| (
		sys-libs/readline:0
		dev-libs/libedit
	)
	system-sqlite? ( >=dev-db/sqlite-3.28.0:3 )
	ssl? ( dev-libs/openssl:0 )
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
	useflags=( legacy-mv-rm miniz tcl-stubs tcl-private-stubs
			   th1-docs th1-hooks )
	for u in ${useflags[@]} ; do
		use ${u} &&  myconf+=" --with-${u}"
	done

	tc-export CC
	./configure ${myconf} || die
}

src_install() {
	dobin fossil
}
