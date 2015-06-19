# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/leveldb/leveldb-1.18.ebuild,v 1.1 2015/02/21 18:34:07 vapier Exp $

EAPI=5

inherit eutils multilib toolchain-funcs versionator

DESCRIPTION="a fast key-value storage library written at Google"
HOMEPAGE="https://github.com/google/leveldb"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+snappy static-libs +tcmalloc"

DEPEND="tcmalloc? ( dev-util/google-perftools )
	snappy? (
		app-arch/snappy
		static-libs? ( app-arch/snappy[static-libs] )
	)"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.18-mips.patch

	local SHARED_MINOR=$(get_version_component_range 2)
	sed \
		-e "s/\(^ SHARED_MINOR =\).*/\1 ${SHARED_MINOR}/" \
		"${FILESDIR}/${PN}-1.9.0-memenv-so.patch" > memenv-so.patch
	epatch memenv-so.patch

	# lacks execution bit
	chmod +x build_detect_platform || die
}

src_configure() {
	# These vars all get picked up by build_detect_platform
	# which the Makefile runs for us automatically.
	tc-export AR CC CXX
	export OPT="-DNDEBUG ${CPPFLAGS}"
	# Probably needs more filling out
	export TARGET_OS
	case ${CHOST} in
	*) TARGET_OS="Linux";;
	esac
	export USE_SNAPPY=$(usex snappy)
	export USE_TCMALLOC=no
}

src_compile() {
	emake $(usex static-libs 'libmemenv.a' 'LIBRARY=') all libmemenv.SHARED
}

src_test() {
	emake check
}

src_install() {
	insinto /usr/include
	doins -r include/* helpers/memenv/memenv.h
	dolib.so libleveldb*$(get_libname)*
	use static-libs && dolib.a libleveldb.a libmemenv.a
	dolib.so libmemenv*$(get_libname)*
}
