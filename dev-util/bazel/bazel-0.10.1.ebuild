# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 java-pkg-2

DESCRIPTION="Fast and correct automated build system"
HOMEPAGE="http://bazel.io/"
SRC_URI="https://github.com/bazelbuild/bazel/releases/download/${PV}/${P}-dist.zip"

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

pkg_setup() {
	echo ${PATH} | grep -q ccache && \
		ewarn "${PN} usually fails to compile with ccache, you have been warned"
	java-pkg-2_pkg_setup
}

src_compile() {
	# F: fopen_wr
	# S: deny
	# P: /proc/self/setgroups
	# A: /proc/self/setgroups
	# R: /proc/24939/setgroups
	# C: /usr/lib/systemd/systemd
	addpredict /proc
	VERBOSE=yes ./compile.sh || die
	# Use standalone strategy to deactivate the bazel sandbox, since it
	# conflicts with FEATURES=sandbox.
	echo "build --verbose_failures --spawn_strategy=standalone --genrule_strategy=standalone" \
		> "${T}/bazelrc" || die
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
