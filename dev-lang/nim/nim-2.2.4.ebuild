# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ATLAS_V="0.8.0"

inherit edo multiprocessing shell-completion toolchain-funcs xdg-utils

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
KEYWORDS="amd64 ~arm ~x86"

IUSE="test-js test"
RESTRICT="!test? ( test )"

BDEPEND="
	sys-process/parallel
	test? (
		dev-db/sqlite:3
		dev-libs/boehm-gc
		dev-libs/libffi
		dev-libs/libpcre:3
		dev-libs/openssl
		media-libs/libsdl
		media-libs/libsfml
		test-js? (
			net-libs/nodejs
		)
	)
"

PATCHES=( "${FILESDIR}/${PN}-2.2.0-makefile.patch" )

src_configure() {
	xdg_environment_reset  # bug #667182

	unset NIMBLE_DIR
	tc-export CC CXX LD

	mkdir -p "${HOME}/.parallel" || die
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

	mkdir -p "${S}/dist/atlas/dist" || die
	cp -r "${S}/dist/nimble/vendor/sat" "${S}/dist/atlas/dist/sat" || die
}

src_compile() {
	emake CC="$(tc-getCC)"

	local -x PATH="${S}/bin:${PATH}"
	local -a nimflags=(
		-d:release
		--listCmd
		--parallelBuild:$(makeopts_jobs)
	)

	edo ./bin/nim compile "${nimflags[@]}" koch
	edo ./koch boot "${nimflags[@]}" -d:nimUseLinenoise --skipParentCfg:off
	edo ./koch tools "${nimflags[@]}"
	edo ./bin/nim compile "${nimflags[@]}" ./tools/niminst/niminst.nim
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
		--skipFrom:"${FILESDIR}/nim-2.2.2-testament-skipfile.txt"
		--nim:"bin/nim"
		--targets:"$(usex test-js 'c js' 'c')"
	)

	if [[ "${NOCOLOR}" == true || "${NOCOLOR}" == yes ]] ; then
		testament_args+=( --colors:off )
	fi

	local -a categories=()
	readarray -t categories < \
		<(find tests -mindepth 1 -maxdepth 1 -type d -printf "%P\n" | sort)

	# AdditionalCategories from "testament/categories.nim".
	categories+=( debugger examples lib )

	local test_return=0

	local tcat=""
	local checkpoint=""
	for tcat in "${categories[@]}"; do
		# Use checkpoints for less painful testing.
		checkpoint="${T}/.testament-${tcat}"

		if [[ -f "${checkpoint}" ]] ; then
			continue
		fi

		case "${tcat}" in
			testdata )
				:
				;;

			arc | async | coroutines | errmsgs | exception | gc | \
			ic | int | js | msgs | objects | overflow | \
			stdlib | stylecheck | system | testament | untestable | \
			valgrind )
				einfo "Skipped nim test category: ${tcat}"
				;;

			* )
				einfo "Running tests in category '${tcat}'..."

				nonfatal \
					edo ./bin/testament "${testament_args[@]}" \
					category "${tcat}" "${nimflags[@]}" \
					|| test_return=1
				;;
		esac

		touch "${checkpoint}" || die
	done

	if [[ "${test_return}" -eq 1 ]] ; then
		die "tests failed, please inspect the failed test categories above"
	fi
}

src_install() {
	local -x PATH="${S}/bin:${PATH}"

	edo ./koch install "${ED}/usr/lib"
	dosym -r /usr/lib/nim/bin/nim /usr/bin/nim

	# "./koch install" installs only "nim" binary but not the rest.
	local exe=""
	while read -r exe ; do
		einfo "Installing nim support tool: ${exe}"

		exeinto /usr/bin
		doexe "${exe}"
	done < \
		 <(find ./bin -type f -not -iname nim)

	newbashcomp dist/nimble/nimble.bash-completion nimble
	newbashcomp tools/nim.bash-completion nim
	newzshcomp dist/nimble/nimble.zsh-completion _nimble
	newzshcomp tools/nim.zsh-completion _nim

	# Install the @nim-rebuild set for Portage.
	insinto /usr/share/portage/config/sets
	newins "${FILESDIR}/nim-sets.conf" nim.conf

	einstalldocs
}
