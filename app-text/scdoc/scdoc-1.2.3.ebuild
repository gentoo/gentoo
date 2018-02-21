# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Standalone tool for generating man pages with a simple syntax"
HOMEPAGE="https://git.sr.ht/~sircmpwn/scdoc"
SRC_URI="https://git.sr.ht/~sircmpwn/scdoc/snapshot/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default

	sed -i 's/-Werror//' Makefile || die 'Failed to remove -Werror'
	sed -i 's/CFLAGS=/CFLAGS+=/' Makefile || die 'Failed to patch makefile'
}

src_compile() {
	MY_HS="./scdoc"
	if tc-is-cross-compiler; then
		tc-export_build_env
		MY_HS="./hostscdoc"
		MAKEOPTS+=" HOST_SCDOC=./hostscdoc"
		emake scdoc OUTDIR="${S}/.build.host" CC=$(tc-getBUILD_CC) \
			CFLAGS="${BUILD_CFLAGS}" LDFLAGS="${BUILD_LDFLAGS}"
		mv scdoc hostscdoc || die 'Failed to rename host scdoc'
	fi
	emake LDFLAGS="${LDFLAGS}" HOST_SCDOC="${MY_HS}"
}

src_install() {
	emake DESTDIR="${D}" HOST_SCDOC="${MY_HS}" install
}
