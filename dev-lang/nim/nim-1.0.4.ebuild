# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 multiprocessing toolchain-funcs

DESCRIPTION="compiled, garbage-collected systems programming language"
HOMEPAGE="https://nim-lang.org/"
SRC_URI="https://nim-lang.org/download/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc +readline test"

RESTRICT=test # need to sort out depends and numerous failures

RDEPEND="
	readline? ( sys-libs/readline:0= )
"
DEPEND="
	${DEPEND}
	test? ( net-libs/nodejs )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.20.0-paths.patch
)

_run() {
	echo "$@"
	"$@" || die "'$*' failed"
}

nim_use_enable() {
	[[ -z $2 ]] && die "usage: nim_use_enable <USE flag> <compiler flag>"
	use $1 && echo "-d:$2"
}

src_compile() {
	export XDG_CACHE_HOME=${T}/cache #667182
	tc-export CC LD

	_run ./build.sh

	_run ./bin/nim --parallelBuild:$(makeopts_jobs) c koch
	_run ./koch boot --parallelBuild:$(makeopts_jobs) -d:release $(nim_use_enable readline useGnuReadline)
	# build nimble and friends
	# --stable to avoid pulling HEAD nimble
	PATH="./bin:$PATH" _run ./koch --stable tools

	if use doc; then
		PATH="./bin:$PATH" _run ./koch doc
	fi
}

src_test() {
	PATH="./bin:$PATH" _run ./koch test
}

src_install() {
	PATH="./bin:$PATH" _run ./koch install "${ED}"
	rm -r "${ED}/usr/share/nim/doc" || die "failed to remove 'doc'"

	exeinto /usr/bin

	local bin_exe
	for bin_exe in bin/*; do
		# './koch install' installs only 'nim' binary
		# but not the rest
		[[ ${bin_exe} == bin/nim ]] && continue
		doexe "${bin_exe}"
	done

	use doc && dodoc doc/html/*.html
	newbashcomp tools/nim.bash-completion ${PN}
}
