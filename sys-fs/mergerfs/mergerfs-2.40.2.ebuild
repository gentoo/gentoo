# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A featureful union filesystem"
HOMEPAGE="https://github.com/trapexit/mergerfs"
SRC_URI="https://github.com/trapexit/mergerfs/archive/${PV}.tar.gz -> ${P}.tar.gz"

# Vendorized libfuse that's bundled is under LGPL-2.1.
LICENSE="ISC LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"
IUSE="+xattr"

DEPEND="
	xattr? ( sys-apps/attr )
"
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/gettext"

src_prepare() {
	default

	# Hand made build system at its finest.
	echo -e "#!/bin/sh\ntrue" > buildtools/update-version || die
	cat <<-EOF > src/version.hpp || die
	#pragma once
	static const char MERGERFS_VERSION[] = "${PV}";
	EOF

	if ! use xattr; then
		sed -i -e 's%USE_XATTR = 1%USE_XATTR = 0%g' Makefile || die
	fi
}

src_compile() {
	# https://bugs.gentoo.org/725978
	tc-export AR CC CXX

	default
}

src_install() {
	dobin build/mergerfs
	dosym mergerfs /usr/bin/mount.mergerfs
	dodoc README.md
	doman man/mergerfs.1
}
