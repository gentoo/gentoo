# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib toolchain-funcs

DESCRIPTION="a fast key-value storage library written at Google"
HOMEPAGE="http://leveldb.org/ https://github.com/google/leveldb"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
# https://github.com/google/leveldb/issues/536
SLOT="0/1"
KEYWORDS="amd64 arm arm64 ~mips ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="+snappy static-libs kernel_FreeBSD +tcmalloc test"
RESTRICT="!test? ( test )"

DEPEND="tcmalloc? ( dev-util/google-perftools )
	snappy? (
		app-arch/snappy:=
	)"
RDEPEND="${DEPEND}"

# https://bugs.gentoo.org/651604
REQUIRED_USE="snappy? ( !static-libs )"

# https://github.com/google/leveldb/issues/234
# https://github.com/google/leveldb/issues/236
PATCHES=( "${FILESDIR}"/{${PN}-1.18-configure.patch,${P}-memenv-so.patch} )

src_configure() {
	# These vars all get picked up by build_detect_platform
	tc-export AR CC CXX
	export OPT="-DNDEBUG ${CPPFLAGS}"

	TARGET_OS=$(usex kernel_FreeBSD FreeBSD Linux) \
	USE_SNAPPY=$(usex snappy) \
	USE_TCMALLOC=no \
	TMPDIR=${T} \
	sh -x ./build_detect_platform build_config.mk ./ || die
}

src_compile() {
	default
	usex static-libs && emake out-static/lib{leveldb,memenv}.a
	use test && emake static_programs
}

src_test() {
	emake check
}

src_install() {
	insinto /usr/include
	doins -r include/.
	# This matches the path Debian picked. Upstream provides no guidance.
	insinto /usr/include/leveldb/helpers
	doins helpers/memenv/memenv.h

	dolib.so out-shared/libleveldb*$(get_libname)*
	use static-libs && dolib.a out-static/lib{leveldb,memenv}.a
	dolib.so out-shared/libmemenv*$(get_libname)*
}
