# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ATLAS_V="0.8.0"

inherit bash-completion-r1 edo multiprocessing toolchain-funcs xdg-utils

DESCRIPTION="Compiled, garbage-collected systems programming language"
HOMEPAGE="https://nim-lang.org/
	https://github.com/nim-lang/Nim/"
SRC_URI="
	https://nim-lang.org/download/${P}.tar.xz
	https://github.com/nim-lang/atlas/archive/refs/tags/${ATLAS_V}.tar.gz
		-> nim-atlas-${ATLAS_V}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test-js test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-db/sqlite:3
		dev-libs/boehm-gc
		dev-libs/libffi
		dev-libs/libpcre:3
		dev-libs/openssl
		media-libs/libsdl
		media-libs/libsfml
	)
"
BDEPEND="
	sys-process/parallel
	test? (
		test-js? (
			net-libs/nodejs
		)
	)
"

src_configure() {
	xdg_environment_reset  # bug #667182

	unset NIMBLE_DIR
	tc-export CC CXX LD

	mkdir "${HOME}/.parallel" || die
	touch "${HOME}/.parallel/will-cite" || die "parallel setup failed"

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

		# some tests don't work with processing hints
		--processing:"off"
	EOF

	cp -r "${WORKDIR}/atlas-${ATLAS_V}" "${S}/dist/atlas" || die
}

src_compile() {
	local -x PATH="${S}/bin:${PATH}"

	edo ./build.sh --parallel "$(makeopts_jobs)"

	ebegin "Waiting for unfinished parallel jobs"
	while [[ ! -f "bin/nim" ]] ; do
		sleep 3
	done
	sleep 10
	eend 0

	edo chmod +x ./bin/nim
	edo ./bin/nim compile -d:release koch
	edo ./koch boot -d:nimUseLinenoise -d:release --skipParentCfg:off
	edo ./koch tools -d:release
	edo ./bin/nim compile -d:release ./tools/niminst/niminst.nim
}

src_test() {
	local -x PATH="${S}/bin:${PATH}"
	local -a nimflags=(
		# Leave only the safe hints enabled.
		--hint:all:off
		--hint:User:on
		--hint:UserRaw:on
	)
	local -a testament_args=(
		--skipFrom:"${FILESDIR}/${PN}-2.0.6-testament-skipfile.txt"
		--nim:"bin/nim"
		--targets:"$(usex test-js 'c js' 'c')"
	)

	[[ "${NOCOLOR}" == true || "${NOCOLOR}" == yes ]] \
		&& testament_args+=( --colors:off )

	local -a categories
	readarray -t categories < <(find tests -mindepth 1 -maxdepth 1 -type d -printf "%P\n" | sort)

	# AdditionalCategories from "testament/categories.nim".
	categories+=( debugger examples lib )

	local test_return=0

	local tcat
	local checkpoint
	for tcat in "${categories[@]}"; do
		# Use checkpoints for less painful testing.
		checkpoint="${T}/.testament-${tcat}"

		[[ -f "${checkpoint}" ]] && continue

		case "${tcat}" in
			testdata )
				:
				;;
			arc | gc | ic | js | msgs | stylecheck \
				| testament | untestable | objects | valgrind )
				einfo "Skipped nim test category: ${tcat}"
				;;
			* )
				einfo "Running tests in category '${tcat}'"
				nonfatal edo ./bin/testament "${testament_args[@]}" \
						 category "${tcat}" "${nimflags[@]}" \
					|| test_return=1
				;;
		esac

		touch "${checkpoint}" || die
	done

	[[ "${test_return}" -eq 1 ]] \
		&& die "tests failed, please inspect the failed test categories above"
}

src_install() {
	local -x PATH="${S}/bin:${PATH}"

	edo ./koch install "${ED}/usr/lib"
	dosym -r /usr/lib/nim/bin/nim /usr/bin/nim

	# "./koch install" installs only "nim" binary but not the rest.
	exeinto /usr/bin
	local exe
	while read -r exe ; do
		einfo "Installing nim support tool: ${exe}"
		doexe "${exe}"
	done < <(find ./bin -type f -not -iname nim)

	newbashcomp tools/nim.bash-completion nim
	newbashcomp dist/nimble/nimble.bash-completion nimble

	insinto /usr/share/zsh/site-functions
	newins tools/nim.zsh-completion _nim
	newins dist/nimble/nimble.zsh-completion _nimble

	# Install the @nim-rebuild set for Portage.
	insinto /usr/share/portage/config/sets
	newins "${FILESDIR}/nim-sets.conf" nim.conf

	einstalldocs
}
