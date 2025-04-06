# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

MY_PV="${PV}_14-Nov-2020"

DESCRIPTION="FASTA is a DNA and Protein sequence alignment software package"
HOMEPAGE="https://fasta.bioch.virginia.edu/fasta_www2/fasta_down.shtml"
SRC_URI="https://github.com/wrpearson/fasta36/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}36-${MY_PV}"

LICENSE="fasta"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="debug cpu_flags_x86_sse2"

PATCHES=(
	"${FILESDIR}/${PN}-36.3.8i-musl-build-fix.patch"
)

src_prepare() {
	CC_ALT=
	CFLAGS_ALT=
	ALT=

	use debug && append-flags -DDEBUG

	if [[ "$(tc-getCC)" == *icc* ]]; then
		CC_ALT=icc
		ALT="${ALT}_icc"
	else
		CC_ALT="$(tc-getCC)"
		use x86 && ALT="32"
		use amd64 && ALT="64"
	fi

	if use cpu_flags_x86_sse2 ; then
		ALT="${ALT}_sse2"
		append-flags -msse2
		[[ "$(tc-getCC)" == *icc* ]] || append-flags -ffast-math
	fi

	export CC_ALT="${CC_ALT}"
	export ALT="${ALT}"

	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/862267
	# https://github.com/wrpearson/fasta36/issues/63
	filter-lto

	sed \
		-e 's:-ffast-math::g' \
		-i make/Makefile* || die

	default
}

src_compile() {
	emake -C src -f ../make/Makefile.linux${ALT} CC="${CC_ALT} ${CFLAGS}" HFLAGS="${LDFLAGS}" all
}

src_test() {
	cd test || die
	FASTLIBS="../conf" bash test.sh || die
}

src_install() {
	dobin bin/*

	pushd bin >/dev/null || die
		local i
		for i in *36; do
			dosym ${i} /usr/bin/${i%36}
		done
	popd >/dev/null || die

	insinto /usr/share/${PN}
	doins -r conf/. data seq

	doman doc/{prss3.1,fasta36.1,fasts3.1,fastf3.1,ps_lav.1,map_db.1}
	dodoc FASTA_LIST README* doc/{README*,readme*,fasta*,changes*}
}
