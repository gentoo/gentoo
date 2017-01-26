# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit bash-completion-r1 java-pkg-2

DESCRIPTION="Bazel build system"
HOMEPAGE="https://bazel.io/"
SRC_URI="https://github.com/bazelbuild/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
# strip corrupts the bazel binary
RESTRICT="strip"
DEPEND="virtual/jdk:1.8"
RDEPEND="${DEPEND}"

src_compile() {
	./compile.sh || die
	# Use standalone strategy to deactivate the bazel sandbox, since it
	# conflicts with FEATURES=sandbox.
	echo "build --spawn_strategy=standalone --genrule_strategy=standalone" \
		> "${T}/bazelrc" || die
	output/bazel --bazelrc="${T}/bazelrc" build //scripts:bazel-complete.bash || die
}

src_install() {
	dobin output/bazel
	newbashcomp bazel-bin/scripts/bazel-complete.bash ${PN}
}
