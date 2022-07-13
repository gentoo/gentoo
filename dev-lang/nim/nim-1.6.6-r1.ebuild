# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 multiprocessing toolchain-funcs xdg-utils

DESCRIPTION="compiled, garbage-collected systems programming language"
HOMEPAGE="https://nim-lang.org/"
SRC_URI="
	https://nim-lang.org/download/${P}.tar.xz
	experimental? ( https://git.sr.ht/~cyber/${PN}-patches/archive/${PV}.tar.gz -> ${PN}-patches-${PV}.tar.gz )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug experimental +readline"
RESTRICT="test"  # need to sort out depends and numerous failures

RDEPEND="readline? ( sys-libs/readline:0= )"
DEPEND="${RDEPEND}"
# BDEPEND="test? ( net-libs/nodejs )"

PATCHES=( "${FILESDIR}"/${PN}-0.20.0-paths.patch )

_run() {
	einfo "Running: ${@}"
	PATH="${S}/bin:${PATH}" "${@}" || die "Failed: \"${*}\""
}

nim_use_enable() {
	[[ -z "${2}" ]] && die "usage: nim_use_enable <USE flag> <compiler flag>"
	use "${1}" && echo "-d:${2}"
}

# Borrowed from nim-utils.eclass (guru overlay).
nim_gen_config() {
	cat > nim.cfg <<- EOF || die "Failed to create Nim config"
	cc:"gcc"
	gcc.exe:"$(tc-getCC)"
	gcc.linkerexe:"$(tc-getCC)"
	gcc.cpp.exe:"$(tc-getCXX)"
	gcc.cpp.linkerexe:"$(tc-getCXX)"
	gcc.options.speed:"${CFLAGS}"
	gcc.options.size:"${CFLAGS}"
	gcc.options.debug:"${CFLAGS}"
	gcc.options.always:"${CPPFLAGS}"
	gcc.options.linker:"${LDFLAGS}"
	gcc.cpp.options.speed:"${CXXFLAGS}"
	gcc.cpp.options.size:"${CXXFLAGS}"
	gcc.cpp.options.debug:"${CXXFLAGS}"
	gcc.cpp.options.always:"${CPPFLAGS}"
	gcc.cpp.options.linker:"${LDFLAGS}"

	$([[ "${NOCOLOR}" == true || "${NOCOLOR}" == yes ]] && echo '--colors:"off"')
	-d:"$(usex debug debug release)"
	--parallelBuild:"$(makeopts_jobs)"
	EOF
}

src_prepare() {
	default

	# note: there are consumers in the ::guru overlay
	use experimental && \
		eapply "${WORKDIR}"/${PN}-patches-${PV}
}

src_configure() {
	xdg_environment_reset  # bug 667182

	unset NIMBLE_DIR
	tc-export CC CXX LD

	nim_gen_config
}

src_compile() {
	_run bash ./build.sh

	_run ./bin/nim compile koch
	_run ./koch boot $(nim_use_enable readline useGnuReadline)
	_run ./koch tools
}

src_test() {
	_run ./koch test
}

src_install() {
	_run ./koch install "${ED}"

	# "./koch install" installs only "nim" binary
	# but not the rest
	exeinto /usr/bin
	local exe
	for exe in bin/* ; do
		[[ "${exe}" == bin/nim ]] && continue
		doexe "${exe}"
	done

	newbashcomp tools/nim.bash-completion nim
	newbashcomp dist/nimble/nimble.bash-completion nimble
}
