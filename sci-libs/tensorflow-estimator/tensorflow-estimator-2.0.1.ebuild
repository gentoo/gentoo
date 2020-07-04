# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7} )
MY_PN="estimator"
MY_PV=${PV/_rc/-rc}
MY_P=${MY_PN}-${MY_PV}

inherit bazel distutils-r1 flag-o-matic toolchain-funcs

DESCRIPTION="A high-level TensorFlow API that greatly simplifies machine learning programming"
HOMEPAGE="https://www.tensorflow.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

bazel_external_uris="
	https://github.com/bazelbuild/rules_cc/archive/0d5f3f2768c6ca2faca0079a997a97ce22997a0c.zip -> bazelbuild-rules_cc-0d5f3f2768c6ca2faca0079a997a97ce22997a0c.zip
	https://github.com/bazelbuild/rules_cc/archive/8bd6cd75d03c01bb82561a96d9c1f9f7157b13d0.zip -> bazelbuild-rules_cc-8bd6cd75d03c01bb82561a96d9c1f9f7157b13d0.zip
	https://github.com/bazelbuild/rules_java/archive/7cf3cefd652008d0a64a419c34c13bdca6c8f178.zip -> bazelbuild-rules_java-7cf3cefd652008d0a64a419c34c13bdca6c8f178.zip"

SRC_URI="https://github.com/tensorflow/${MY_PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	${bazel_external_uris}"

RDEPEND="sci-libs/tensorflow[python,${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-java/java-config"

S="${WORKDIR}/${MY_P}"

DOCS=( CONTRIBUTING.md README.md )

src_unpack() {
	unpack "${P}.tar.gz"
	bazel_load_distfiles "${bazel_external_uris}"
}

src_prepare() {
	bazel_setup_bazelrc
	default
}

src_compile() {
	export JAVA_HOME=$(java-config --jre-home)

	ebazel build //tensorflow_estimator/tools/pip_package:build_pip_package
	ebazel shutdown

	local srcdir="${T}/src"
	mkdir -p "${srcdir}" || die
	bazel-bin/tensorflow_estimator/tools/pip_package/build_pip_package --src "${srcdir}" || die
}

src_install() {
	do_install() {
		cd "${T}/src" || die
		esetup.py install
		python_optimize
	}
	python_foreach_impl do_install

	cd "${S}" || die
	einstalldocs
}
