# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit dot-a edo java-pkg-2 multiprocessing python-any-r1 toolchain-funcs

DESCRIPTION="Fast, scalable, multi-language and extensible build system"
HOMEPAGE="https://bazel.build"
SRC_URI="https://github.com/bazelbuild/bazel/releases/download/${PV}/${P}-dist.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
# https://github.com/bazelbuild/bazel/issues/600
# "We don't expect people to strip it because 99% of the bazel "binary"
# is actually a Java server that is extracted from the zip file and then
# persisted between builds."
# test requires packages not in the dist archive.
RESTRICT="strip test"

DEPEND="virtual/jdk:21"
RDEPEND="
	${DEPEND}
	!dev-build/bazelisk[bazel-symlink]
"
BDEPEND="
	${PYTHON_DEPS}
	app-arch/unzip
	app-arch/zip
"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if has ccache ${FEATURES}; then
			eerror "Building ${PN} with FEATURES=ccache is not 'yet' supported!"
			die "ccache is not supported"
		fi
	fi
}

pkg_setup() {
	java-pkg-2_pkg_setup
	python-any-r1_pkg_setup
}

src_unpack() {
	# dist archive has no parent directory
	mkdir -p "${S}" || die
	pushd "${S}" || die
	unpack ${P}-dist.zip
	popd || die
}

src_compile() {
	lto-guarantee-fat

	local mybazelargs=(
		--jobs="$(get_makeopts_jobs)"
		--spawn_strategy="local" # portage is already sandboxed
		--strip="never"
		--subcommands
		--tool_java_runtime_version=local_jdk
	)

	local cflags
	for cflags in ${CFLAGS}; do
		mybazelargs+=( --conlyopt="${cflags}" )
	done

	local ldflags
	for ldflags in ${LDFLAGS}; do
		mybazelargs+=( --linkopt="${ldflags}" )
	done

	CC=$(tc-getCC) \
	VERBOSE="yes" \
	EXTRA_BAZEL_ARGS="${mybazelargs[@]}" \
	edo ./compile.sh
}

src_install() {
	dobin output/bazel
}
