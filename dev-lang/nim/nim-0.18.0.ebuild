# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 multiprocessing

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

_run() {
	echo "$@"
	"$@" || die "'$*' failed"
}

nim_use_enable() {
	[[ -z $2 ]] && die "usage: nim_use_enable <USE flag> <compiler flag>"
	use $1 && echo "-d:$2"
}

src_compile() {
	_run ./build.sh

	_run ./bin/nim --parallelBuild:$(makeopts_jobs) c koch
	_run ./koch boot --parallelBuild:$(makeopts_jobs) -d:release $(nim_use_enable readline useGnuReadline)
	# build nimble and friends
	PATH="./bin:$PATH" _run ./koch tools

	if use doc; then
		PATH="./bin:$PATH" _run ./koch web
	fi
}

src_test() {
	PATH="./bin:$PATH" _run ./koch test
}

src_install() {
	PATH="./bin:$PATH" _run ./koch install "${ED}/usr"
	rm -r "${ED}/usr/nim/doc" || die "failed to remove 'doc'"

	dodir /usr/bin
	exeinto /usr/nim/bin

	local bin_exe
	for bin_exe in bin/*; do
		# './koch install' installs only 'nim' binary
		# but not the rest
		doexe "${bin_exe}"
		dosym ../nim/"${bin_exe}" /usr/"${bin_exe}"
	done

	if use doc; then
		insinto /usr/share/doc/${PF}
		dodoc doc/*.html
	fi

	newbashcomp tools/nim.bash-completion ${PN}
}
