# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Synchronize two directory trees in a fast way"
HOMEPAGE="https://sourceforge.net/projects/mirdir/"
SRC_URI="mirror://sourceforge/${PN}/${P}-Unix.tar.gz"
S="${WORKDIR}/${P}-UNIX"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1-implicit-function-decl.patch
)

src_prepare() {
	default

	# Disable stripping, bug #239939
	sed -i -e 's:strip .*::' Makefile.in || die
}

src_configure() {
	# Old autoconf gets this test wrong with -flto(!) and there's
	# no source configure.in/.ac in the tarball. bug #854213
	export ac_cv_func_lutime=no

	econf
}

src_install() {
	dobin bin/${PN}
	doman ${PN}.1

	einstalldocs
}
