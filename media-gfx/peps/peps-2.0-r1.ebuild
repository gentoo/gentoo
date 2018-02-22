# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="Preprocess and convert EPS files to bitmap with Ghostscript"
HOMEPAGE="http://peps.redprince.net/peps/"
SRC_URI="http://www.peps.redprince.net/peps/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="X"

DEPEND="app-text/ghostscript-gpl
	app-arch/gzip"
RDEPEND="${DEPEND}"

pkg_setup() {
	if use X && ! grep -q x11gray4 <(gs -h 2>/dev/null); then
		die "you need a ghostscript version with 'x11' and 'x11gray4' devices!"
	fi
}

src_prepare() {
	default
	# adding <string.h> include
	sed -i -e "s:^\(#include.*<unistd.h>.*\):\1\n#include <string.h>:" peps.c || die
	# adding LDFLAGS to Makefile
	sed -i -e "s:\( -o \): \${LDFLAGS}\1:g" Makefile || die
}

src_compile() {
	local myopts="peps"
	use X && myopts="${myopts} xpeps"
	emake CC="$(tc-getCC)" ${myopts}
}

src_install() {
	# manual install, because fixing dumb Makefile is more compilcated
	dobin peps
	use X && dobin xpeps

	doman peps.1
	dodoc README

	insinto /etc
	doins peps.mime

	# copy PDF so it won't be compressed
	cp peps.pdf "${D}usr/share/doc/${PF}" || die
}
