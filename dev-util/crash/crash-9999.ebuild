# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

GDB_VERSION=10.2
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/crash-utility/crash.git"
	SRC_URI="mirror://gnu/gdb/gdb-${GDB_VERSION}.tar.gz"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/crash-utility/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		mirror://gnu/gdb/gdb-${GDB_VERSION}.tar.xz"
	KEYWORDS="-* ~alpha ~amd64 ~arm ~ppc64 ~s390 ~x86"
fi

DESCRIPTION="Red Hat crash utility; used for analyzing kernel core dumps"
HOMEPAGE="https://crash-utility.github.io/"

LICENSE="GPL-3"
SLOT="0"
IUSE="lzo snappy valgrind zstd"
# there is no "make test" target, but there is a test.c so the automatic
# make rules catch it and tests fail
RESTRICT="test"

DEPEND="
	lzo? ( dev-libs/lzo )
	snappy? ( app-arch/snappy )
	valgrind? ( dev-debug/valgrind )
	zstd? ( app-arch/zstd )
"

RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i -e "s|ar -rs|\${AR} -rs|g" Makefile || die
	ln -s "${DISTDIR}"/gdb-10.2.tar.gz . || die
}

src_configure() {
	# bug #858344
	filter-lto

	echo "${CFLAGS}" > CFLAGS.extra || die
	echo "${LDFLAGS}" > LDFLAGS.extra || die

	default
}

src_compile() {
	local opts=(
		$(usev lzo)
		$(usev snappy)
		$(usev valgrind)
		$(usev zstd)
	)

	emake \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		MAKECMDGOALS="${opts[@]}"
}
