# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PATCH_PV="1.6.6_p1"
inherit bash-completion-r1 edo multiprocessing toolchain-funcs xdg-utils

DESCRIPTION="compiled, garbage-collected systems programming language"
HOMEPAGE="https://nim-lang.org/"
SRC_URI="
	https://nim-lang.org/download/${P}.tar.xz
	experimental? (
		https://git.sr.ht/~cyber/${PN}-patches/archive/${PATCH_PV}.tar.gz
			-> nim-patches-${PATCH_PV}.tar.gz
	)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc experimental"
RESTRICT="test"  # need to sort out depends and numerous failures

BDEPEND="sys-process/parallel"

PATCHES=(
	"${FILESDIR}"/${PN}-0.20.0-paths.patch
	"${FILESDIR}"/${PN}-1.6.6-csources-flags.patch
)

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
		-d:"release"
		--parallelBuild:"$(makeopts_jobs)"
	EOF
}

src_prepare() {
	default

	# note: there are consumers in the ::guru overlay
	use experimental && eapply "${WORKDIR}"/nim-patches-${PATCH_PV}
}

src_configure() {
	xdg_environment_reset  # bug 667182

	unset NIMBLE_DIR
	tc-export CC CXX LD

	nim_gen_config

	mkdir "${HOME}"/.parallel || die
	touch "${HOME}"/.parallel/will-cite || die "parallel setup failed"
}

src_compile() {
	local -x PATH="${S}/bin:${PATH}"

	edo ./build.sh --parallel "$(makeopts_jobs)"

	ebegin "Waiting for unfinished jobs"
	while [[ ! -f "bin/nim" ]]; do
		sleep 1
	done
	eend 0

	edo ./bin/nim compile koch
	edo ./koch boot -d:nimUseLinenoise --skipParentCfg:off
	edo ./koch tools

	if use doc; then
		local docargs=(
			# set git tag
			--git.commit:v${PV}
			# skip runnableExamples as some of them need net
			--docCmd:skip
			# make logs less verbose
			--hints:off
			--warnings:off
		)
		edo ./koch doc "${docargs[@]}"
		HTML_DOCS=( web/upload/${PV}/. )
	fi
}

src_test() {
	local -x PATH="${S}/bin:${PATH}"

	edo ./koch test
}

src_install() {
	local -x PATH="${S}/bin:${PATH}"

	edo ./koch install "${ED}"
	einstalldocs

	# "./koch install" installs only "nim" binary
	# but not the rest
	local exe
	for exe in bin/* ; do
		[[ "${exe}" == bin/nim ]] && continue
		dobin "${exe}"
	done

	newbashcomp tools/nim.bash-completion nim
	newbashcomp dist/nimble/nimble.bash-completion nimble

	insinto /usr/share/zsh/site-functions
	newins tools/nim.zsh-completion _nim
	newins dist/nimble/nimble.zsh-completion _nimble

	# install the @nim-rebuild set for Portage
	insinto /usr/share/portage/config/sets
	newins "${FILESDIR}"/nim-sets.conf nim.conf
}
