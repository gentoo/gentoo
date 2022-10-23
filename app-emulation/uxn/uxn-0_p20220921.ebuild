# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=cbc61578b77881232fda4cc42aa914a0806b786f

inherit toolchain-funcs

DESCRIPTION="An assembler and emulator for the Uxn stack-machine, written in ANSI C"
HOMEPAGE="
	https://wiki.xxiivv.com/site/uxn.html
	https://git.sr.ht/~rabbits/uxn/
"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.sr.ht/~rabbits/uxn.git"
else
	SRC_URI="https://git.sr.ht/~rabbits/uxn/archive/${H}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${H}
	KEYWORDS="~amd64 ~x86"
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
