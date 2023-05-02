# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="An assembler and emulator for the Uxn stack-machine, written in ANSI C"
HOMEPAGE="https://wiki.xxiivv.com/site/uxn.html
	https://git.sr.ht/~rabbits/uxn/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.sr.ht/~rabbits/uxn.git"
elif [[ ${PV} == *_p20230501 ]] ; then
	COMMIT=0dcc3b4c2e12bf2a61e682e9168e8bdb469caae0
	SRC_URI="https://git.sr.ht/~rabbits/uxn/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${COMMIT}
	KEYWORDS="~amd64 ~x86"
else
	die "wrong package version (PV), given: ${PV}"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="media-libs/libsdl2:="
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/uxn-build.sh.patch )

src_compile() {
	CC="$(tc-getCC)" CFLAGS="${CFLAGS} ${LDFLAGS}" ./build.sh --no-run ||
		die "build failed"

	local f
	local f_base
	for f in ./projects/{examples/*,software,utils}/*.tal ; do
		f_base="$(basename "${f}" .tal)"
		ebegin "Assembling ROM ${f_base}"
		./bin/uxnasm "${f}" "$(dirname "${f}")"/"${f_base}".rom
		eend ${?} ||  die "failed to assemble ${f}"
	done
}

src_install() {
	exeinto /usr/bin
	doexe bin/uxn*

	insinto /usr/share/uxn
	doins bin/*.rom
	doins -r projects

	einstalldocs
}
