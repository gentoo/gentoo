# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="An assembler and emulator for the Uxn stack-machine, written in ANSI C"
HOMEPAGE="https://wiki.xxiivv.com/site/uxn.html
	https://git.sr.ht/~rabbits/uxn/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://git.sr.ht/~rabbits/${PN}"
elif [[ "${PV}" == *_p20250122 ]] ; then
	COMMIT="e17c610d735f45e7397d750ec82f791d0fdb496b"

	SRC_URI="https://git.sr.ht/~rabbits/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/uxn-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
else
	die "Wrong package version, please update the ebuild, given: ${PV}"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="
	media-libs/libsdl2:=
"
DEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/uxn-0_p20230609-build.sh.patch"
)

src_compile() {
	local -x CC="$(tc-getCC)"
	local -x CFLAGS="${CFLAGS} ${LDFLAGS}"

	./build.sh --no-run || die "building with \"build.sh\" failed"

	# Fails to assemble via following loop.
	# Possibly not mean to be assembled by hand.
	rm -rf ./projects/library ./projects/software/{asma,launcher}.tal || die

	local tal_file=""
	local tal_file_base=""

	while read -r tal_file ; do
		tal_file_base="$(basename "${tal_file}" .tal)"

		ebegin "Assembling ROM ${tal_file_base}"
		./bin/uxnasm "${tal_file}" "$(dirname "${tal_file}")/${tal_file_base}.rom"
		eend ${?} || die "failed to assemble ${tal_file}"
	done < \
		 <(find projects -type f -name "*.tal")
}

src_install() {
	insinto /usr/bin
	doins ./bin/uxn{asm,cli,emu}
	fperms 0755 /usr/bin/uxn{asm,cli,emu}

	insinto /usr/share/uxn
	doins -r ./projects

	einstalldocs
}
