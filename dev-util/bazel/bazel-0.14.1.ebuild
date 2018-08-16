# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 java-pkg-2 multiprocessing

DESCRIPTION="Fast and correct automated build system"
HOMEPAGE="http://bazel.io/"

bazel_external_uris="https://github.com/google/desugar_jdk_libs/archive/f5e6d80c6b4ec6b0a46603f72b015d45cf3c11cd.zip -> google-desugar_jdk_libs-f5e6d80c6b4ec6b0a46603f72b015d45cf3c11cd.zip"
SRC_URI="https://github.com/bazelbuild/bazel/releases/download/${PV}/${P}-dist.zip
	${bazel_external_uris}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples tools zsh-completion"
# strip corrupts the bazel binary
RESTRICT="strip"
RDEPEND="virtual/jdk:1.8"
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

load_distfiles() {
	# Populate the bazel distdir to fetch from since it cannot use the network
	local s d uri rename
	mkdir -p "${T}/bazel-distdir" || die "failed to create distdir"

	while read uri rename d; do
		[[ -z "$uri" ]] && continue
		if [[ "$rename" == "->" ]]; then
			s="${uri##*/}"
			einfo "Copying $d to bazel distdir $s ..."
		else
			s="${uri##*/}"
			d="${s}"
			einfo "Copying $d to bazel distdir ..."
		fi
		cp "${DISTDIR}/${d}" "${T}/bazel-distdir/${s}" || die
	done <<< "${bazel_external_uris}"
}

pkg_setup() {
	echo ${PATH} | grep -q ccache && \
		ewarn "${PN} usually fails to compile with ccache, you have been warned"
	java-pkg-2_pkg_setup
}

src_unpack() {
	# Only unpack the main distfile
	unpack ${P}-dist.zip
}

src_prepare() {
	load_distfiles
	default

	# F: fopen_wr
	# S: deny
	# P: /proc/self/setgroups
	# A: /proc/self/setgroups
	# R: /proc/24939/setgroups
	# C: /usr/lib/systemd/systemd
	addpredict /proc

	# Use standalone strategy to deactivate the bazel sandbox, since it
	# conflicts with FEATURES=sandbox.
	cat > "${T}/bazelrc" <<-EOF
	build --verbose_failures
	build --spawn_strategy=standalone --genrule_strategy=standalone

	build --experimental_distdir=${T}/bazel-distdir
	build --jobs=$(makeopts_jobs) $(bazel-get-flags)

	test --verbose_failures --verbose_test_summary
	test --spawn_strategy=standalone --genrule_strategy=standalone
	EOF

	echo "import ${T}/bazelrc" >> "${S}/.bazelrc"
}

src_compile() {
	export EXTRA_BAZEL_ARGS="--jobs=$(makeopts_jobs)"
	VERBOSE=yes ./compile.sh || die
	output/bazel --bazelrc="${T}/bazelrc" build scripts:bazel-complete.bash || die
	mv bazel-bin/scripts/bazel-complete.bash output/ || die
}

src_test() {
	output/bazel test \
		--verbose_failures \
		--spawn_strategy=standalone \
		--genrule_strategy=standalone \
		--verbose_test_summary \
		examples/cpp:hello-success_test || die
}

src_install() {
	output/bazel shutdown
	dobin output/bazel
	newbashcomp output/bazel-complete.bash ${PN}
	bashcomp_alias ${PN} ibazel
	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		doins scripts/zsh_completion/_bazel
	fi
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
	fi
}
