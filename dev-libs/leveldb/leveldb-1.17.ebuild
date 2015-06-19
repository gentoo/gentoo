# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/leveldb/leveldb-1.17.ebuild,v 1.4 2015/02/21 18:18:13 vapier Exp $

EAPI=5

inherit eutils multilib toolchain-funcs versionator

GITCRAP="e353fbc7ea81"

DESCRIPTION="a fast key-value storage library written at Google"
HOMEPAGE="https://github.com/google/leveldb"
#SRC_URI="https://${PN}.googlecode.com/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="http://dev.gentoo.org/~floppym/dist/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+snappy static-libs +tcmalloc"

DEPEND="tcmalloc? ( dev-util/google-perftools )
	snappy? (
		app-arch/snappy
		static-libs? ( app-arch/snappy[static-libs] )
	)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${GITCRAP}"

src_prepare() {
	local SHARED_MINOR=$(get_version_component_range 2)
	cp "${FILESDIR}/${PN}-1.9.0-memenv-so.patch" "${S}/patch"
	sed -i "s/\(^ SHARED_MINOR =\).*/\1 ${SHARED_MINOR}/" "${S}/patch"
	epatch "${S}/patch"

	# lacks execution bit
	chmod +x "${S}"/build_detect_platform || die
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
	emake $(usex static-libs '' 'LIBRARY=') all libmemenv.a libmemenv.SHARED
}

src_test() {
	emake check
}

src_install() {
	insinto /usr/include
	doins -r include/* helpers/memenv/memenv.h
	dolib.so libleveldb*$(get_libname)*
	use static-libs && dolib.a libleveldb.a
	dolib.a libmemenv.a
	dolib.so libmemenv*$(get_libname)*
}
