# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

# source maintainers named it fxload-YYYY_MM_DD instead of fxload-YYYYMMDD
MY_P="${PN}-${PV:0:4}_${PV:4:2}_${PV:6:2}"
DESCRIPTION="USB firmware uploader"
HOMEPAGE="http://linux-hotplug.sourceforge.net/"
SRC_URI="mirror://sourceforge/linux-hotplug/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ppc ppc64 sparc x86"

src_prepare() {
	default

	sed -i \
		-e 's:$(CC) -o:$(CC) $(CPPFLAGS) $(LDFLAGS) -o:' \
		Makefile || die
}

src_compile() {
	tc-export CC
	emake RPM_OPT_FLAGS="${CFLAGS}"
}

src_install() {
	emake prefix="${D}" install
	dodoc README.txt
}
