# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ ${PV} == *_p20221211 ]] && COMMIT=6317b5cf181e56253da10e0e5051ac75bbb5c4b2

inherit toolchain-funcs

DESCRIPTION="An assembler and emulator for the Uxn stack-machine, written in ANSI C"
HOMEPAGE="https://wiki.xxiivv.com/site/uxn.html
	https://git.sr.ht/~rabbits/uxn/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.sr.ht/~rabbits/uxn.git"
else
	SRC_URI="https://git.sr.ht/~rabbits/uxn/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${COMMIT}
	KEYWORDS="amd64 ~x86"
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
	for f in ./projects/{examples/*,software,utils}/*.tal ; do
		./bin/uxnasm "${f}" "$(dirname "${f}")"/"$(basename "${f}" .tal)".rom ||
			die "failed to assemble ${f}"
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
