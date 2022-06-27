# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Standalone tool for generating man pages with a simple syntax"
HOMEPAGE="https://git.sr.ht/~sircmpwn/scdoc"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://git.sr.ht/~sircmpwn/scdoc"
	inherit git-r3
else
	SRC_URI="https://git.sr.ht/~sircmpwn/scdoc/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

LICENSE="MIT"
SLOT="0"

src_prepare() {
	default

	sed -e 's/-Werror//' \
		-i Makefile || die 'Failed to patch Makefile'
}

src_compile() {
	local MY_HS="./scdoc"
	if tc-is-cross-compiler; then
		tc-export_build_env
		MY_HS="./hostscdoc"
		emake scdoc HOST_SCDOC="./hostscdoc" OUTDIR="${S}/.build.host" CC="$(tc-getBUILD_CC)" \
			CFLAGS="${BUILD_CFLAGS} -DVERSION='\"${PV}\"'" LDFLAGS="${BUILD_LDFLAGS}"
		mv scdoc hostscdoc || die 'Failed to rename host scdoc'
	fi

	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" PREFIX="${EPREFIX}/usr" HOST_SCDOC="${MY_HS}"
}

src_install() {
	emake DESTDIR="${ED}" PREFIX="${EPREFIX}/usr" HOST_SCDOC="${MY_HS}" \
		PCDIR="/usr/$(get_libdir)/pkgconfig" install
}
