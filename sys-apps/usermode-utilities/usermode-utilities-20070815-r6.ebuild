# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Tools for use with Usermode Linux virtual machines"
HOMEPAGE="http://user-mode-linux.sourceforge.net/"
SRC_URI="http://user-mode-linux.sourceforge.net/uml_utilities_${PV}.tar.bz2"

S="${WORKDIR}"/tools-${PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="fuse"

RDEPEND="
	fuse? ( sys-fs/fuse:0= )
	sys-libs/readline:0=
"
DEPEND="${RDEPEND}"

PATCHES=(
	# Merge previous patches with fix for bug #331099
	"${FILESDIR}"/${P}-rollup.patch
	# Fix owner of humfsify; bug #364531
	"${FILESDIR}"/${P}-humfsify-owner.patch
	"${FILESDIR}"/${P}-headers.patch #580816
	# Fix build /w clang-16, bug #898550
	"${FILESDIR}"/${PN}-fix-memset.patch
	"${FILESDIR}"/${PN}-gcc14-build-fix.patch
)

src_prepare() {
	default
	sed -i -e 's:-o \$(BIN):$(LDFLAGS) -o $(BIN):' "${S}"/*/Makefile || die "LDFLAGS sed failed"
	sed -i -e 's:-o \$@:$(LDFLAGS) -o $@:' "${S}"/moo/Makefile || die "LDFLAGS sed (moo) failed"
	if ! use fuse; then
		einfo "Skipping build of umlmount to avoid sys-fs/fuse dependency."
		sed -i -e 's/\<umlfs\>//' Makefile || die "sed to remove sys-fs/fuse dependency failed"
	fi
}

src_compile() {
	tc-export AR CC
	emake CFLAGS="${CFLAGS} ${CPPFLAGS} -DTUNTAP -D_FILE_OFFSET_BITS=64 -D_LARGEFILE64_SOURCE -g -Wall" all
}
