# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 java-pkg-2 multiprocessing

DESCRIPTION="Fast and correct automated build system"
HOMEPAGE="https://bazel.build/"

GLIBC_GETTID_PATCH="${PN}-1.2.0-rename-gettid-functions.patch"
SRC_URI="https://github.com/bazelbuild/bazel/releases/download/${PV}/${P}-dist.zip
	https://raw.githubusercontent.com/clearlinux-pkgs/bazel/adefd9046582cb52f39579033132e6265ef6ddb0/rename-gettid-functions.patch -> ${GLIBC_GETTID_PATCH}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples tools"
# strip corrupts the bazel binary
# test fails with network-sandbox: An error occurred during the fetch of repository 'io_bazel_skydoc' (bug 690794)
RESTRICT="strip test"
RDEPEND=">=virtual/jdk-1.8:*"
DEPEND="${RDEPEND}
	app-arch/unzip
	app-arch/zip"

S="${WORKDIR}"

bazel-get-flags() {
	local i fs=()
	for i in ${CFLAGS}; do
		fs+=( "--copt=${i}" "--host_copt=${i}" )
	done
	for i in ${CXXFLAGS}; do
		fs+=( "--cxxopt=${i}" "--host_cxxopt=${i}" )
	done
	for i in ${CPPFLAGS}; do
		fs+=( "--copt=${i}" "--host_copt=${i}" )
		fs+=( "--cxxopt=${i}" "--host_cxxopt=${i}" )
	done
	for i in ${LDFLAGS}; do
		fs+=( "--linkopt=${i}" "--host_linkopt=${i}" )
	done
	echo "${fs[*]}"
}

pkg_setup() {
	echo ${PATH} | grep -q ccache && \
		ewarn "${PN} usually fails to compile with ccache, you have been warned"
	java-pkg-2_pkg_setup
}

src_unpack() {
	# Only unpack the main distfile
	unpack ${P}-dist.zip
	pushd third_party/grpc/src >/dev/null || die
	eapply "${DISTDIR}/${GLIBC_GETTID_PATCH}"
	popd >/dev/null || die
}

src_prepare() {
	default

	# F: fopen_wr
	# S: deny
	# P: /proc/self/setgroups
	# A: /proc/self/setgroups
	# R: /proc/24939/setgroups
	# C: /usr/lib/systemd/systemd
	addpredict /proc
}

src_compile() {
	export EXTRA_BAZEL_ARGS="--jobs=$(makeopts_jobs) $(bazel-get-flags) --host_javabase=@local_jdk//:jdk"
	VERBOSE=yes ./compile.sh || die

	./scripts/generate_bash_completion.sh \
		--bazel=output/bazel \
		--output=bazel-complete.bash \
		--prepend=scripts/bazel-complete-header.bash \
		--prepend=scripts/bazel-complete-template.bash
}

src_test() {
	output/bazel test \
		--verbose_failures \
		--spawn_strategy=standalone \
		--genrule_strategy=standalone \
		--verbose_test_summary \
		examples/cpp:hello-success_test || die
	output/bazel shutdown
}

src_install() {
	dobin output/bazel
	newbashcomp bazel-complete.bash ${PN}
	bashcomp_alias ${PN} ibazel
	insinto /usr/share/zsh/site-functions
	doins scripts/zsh_completion/_bazel

	if use examples; then
		docinto examples
		dodoc -r examples/*
		docompress -x /usr/share/doc/${PF}/examples
	fi
	# could really build tools but I don't know which ones
	# are actually used
	if use tools; then
		docinto tools
		dodoc -r tools/*
		docompress -x /usr/share/doc/${PF}/tools
		docompress -x /usr/share/doc/${PF}/tools/build_defs/pkg/testdata
	fi
}
