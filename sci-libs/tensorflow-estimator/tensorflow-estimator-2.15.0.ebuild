# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
MY_PN="estimator"
MY_PV=${PV/_rc/-rc}
MY_P=${MY_PN}-${MY_PV}

inherit bazel distutils-r1

DESCRIPTION="A high-level TensorFlow API that greatly simplifies machine learning programming"
HOMEPAGE="https://www.tensorflow.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

bazel_external_uris="
	https://github.com/bazelbuild/rules_cc/releases/download/0.0.2/rules_cc-0.0.2.tar.gz -> bazelbuild-rules_cc-0.0.2.tar.gz
	https://github.com/bazelbuild/rules_java/archive/7cf3cefd652008d0a64a419c34c13bdca6c8f178.zip -> bazelbuild-rules_java-7cf3cefd652008d0a64a419c34c13bdca6c8f178.zip"

SRC_URI="https://github.com/tensorflow/${MY_PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	${bazel_external_uris}"

RDEPEND="
	=sci-libs/tensorflow-2.15*[python,${PYTHON_USEDEP}]
	sci-libs/keras[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/unzip
	>=dev-build/bazel-5.3.0
	dev-java/java-config
"

S="${WORKDIR}/${MY_P}"

DOCS=( CONTRIBUTING.md README.md )

PATCHES=(
	"${FILESDIR}"/0001-Revert-Exclude-extractor_wrapper-and-generator_wrapp.patch
	"${FILESDIR}"/0002-Revert-Update-TF-Estimator-to-use-new-TF-API-Generat.patch
)

src_unpack() {
	unpack "${P}.tar.gz"
	bazel_load_distfiles "${bazel_external_uris}"
}

src_prepare() {
	bazel_setup_bazelrc
	default
	python_copy_sources
}

python_compile() {
	pushd "${BUILD_DIR}" >/dev/null || die

	ebazel build //tensorflow_estimator/tools/pip_package:build_pip_package
	ebazel shutdown

	local srcdir="${T}/src-${EPYTHON/./_}"
	mkdir -p "${srcdir}" || die
	bazel-bin/tensorflow_estimator/tools/pip_package/build_pip_package --src "${srcdir}" || die

	popd >/dev/null || die
}

src_compile() {
	export JAVA_HOME=$(java-config --jre-home)
	distutils-r1_src_compile
}

python_install() {
	pushd "${T}/src-${EPYTHON/./_}" >/dev/null || die
	esetup.py install
	python_optimize
	popd >/dev/null || die
}
