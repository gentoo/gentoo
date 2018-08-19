# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="A featureful FUSE union filesystem across multiple drives"
HOMEPAGE="https://github.com/trapexit/mergerfs"
SRC_URI="https://github.com/trapexit/mergerfs/releases/download/${PV}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+xattr"
# mergerfs bundles its own _patched_ copy of libfuse.
# No easy way around it yet. :(
#IUSE="${IUSE} +external-fuse"

DEPEND="xattr? ( sys-apps/attr )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile-don-t-touch-LDFLAGS.patch
)

domake() {
	local makevars=(
		# the Makefile uses `which` to obtain full paths to standard utils,
		# However, `which` may not be installed, so override them here.
		MKDIR="$(type -P mkdir)"
		TOUCH="$(type -P touch)"
		CP="$(type -P cp)"
		LN="$(type -P ln)"
		INSTALL="$(type -P install)"

		STRIP='true'
		PANDOC='' # don't rebuild manpages

		XATTR_AVAILABLE="$(usex xattr 1 0)"
		PREFIX="${EPREFIX:-/usr}"
		CXX="$(tc-getCXX)"
		OPTS="${CPPFLAGS} ${CXXFLAGS}"
	)

	emake "${makevars[@]}" "$@"
}

src_prepare() {
	default

	# don't rebuild version.hpp
	cat > tools/update-version <<-'EOFF' || die
		#!/bin/sh
		exit 0
	EOFF

	pushd libfuse >/dev/null || die
	# mostly taken from sys-fs/fuse-2.9.7.ebuild:
	# sandbox violation with mtab writability wrt #438250
	sed -i 's:umount --fake:true --fake:' configure.ac || die
	# end of taken from sys-fs/fuse-2.9.7.ebuild

	# mergerfs Makefile will trigger autoreconf.
	# Do it right ourselves
	eautoreconf
	popd >/dev/null || die
}

src_configure() {
	pushd libfuse >/dev/null || die
	econf --enable-lib --disable-util --disable-example
	popd >/dev/null || die
}

src_compile() {
	pushd libfuse >/dev/null || die
	# emake, not domake since libfuse has a regular autotools build system
	# Run make ourselves, so that all build-related env variables are passed properly
	emake
	popd >/dev/null || die

	domake
}

src_install() {
	domake install DESTDIR="${D}"
	einstalldocs
}
