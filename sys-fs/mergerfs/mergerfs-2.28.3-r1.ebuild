# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A featureful union filesystem"
HOMEPAGE="https://github.com/trapexit/mergerfs"

SRC_URI="https://github.com/trapexit/mergerfs/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 x86"

# Vendorized libfuse that's bundled is under LGPL-2.1.
LICENSE="ISC LGPL-2.1"
SLOT="0"
IUSE="+xattr"

DEPEND="
	xattr? ( sys-apps/attr )
"

RDEPEND="${DEPEND}"

BDEPEND="sys-devel/gettext"

src_prepare() {
	default

	# drop -O2 from those handmade Makefiles.
	sed -r '/^OPTS[ \t]*=/d' -i Makefile || die

	# Hand made build system at it's finest.
	echo -e "#!/bin/sh\ntrue" >tools/update-version || die
	echo "#pragma once" >src/version.hpp || die
	echo "static const char MERGERFS_VERSION[] = \"${PV}\";" >>src/version.hpp || die

	if ! use xattr; then
		sed 's%USE_XATTR = 1%USE_XATTR = 0%g' -i Makefile || die
	fi
}

src_install() {
	dobin build/mergerfs
	dosym mergerfs /usr/bin/mount.mergerfs
	dodoc README.md
	doman man/mergerfs.1
}
