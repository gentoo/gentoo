# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit bazel distutils-r1

DESCRIPTION="Deep Learning for humans"
HOMEPAGE="https://keras.io/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

bazel_external_uris="
	https://github.com/bazelbuild/rules_cc/releases/download/0.0.2/rules_cc-0.0.2.tar.gz -> bazelbuild-rules_cc-0.0.2.tar.gz
	https://github.com/bazelbuild/rules_java/archive/7cf3cefd652008d0a64a419c34c13bdca6c8f178.zip -> bazelbuild-rules_java-7cf3cefd652008d0a64a419c34c13bdca6c8f178.zip"

SRC_URI="https://github.com/keras-team/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${bazel_external_uris}"

RDEPEND="
	>=dev-libs/protobuf-3.13.0:=
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.13.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=sci-libs/keras-applications-1.0.8[${PYTHON_USEDEP}]
	>=sci-libs/keras-preprocessing-1.1.2[${PYTHON_USEDEP}]
	>=sci-libs/tensorflow-2.15[python,${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
BDEPEND="
	app-arch/unzip
	>=dev-libs/protobuf-3.13.0
	dev-java/java-config
	>=dev-build/bazel-5.3.0"

# Bazel tests not pytest, also want GPU access
RESTRICT="test"
DOCS=( CONTRIBUTING.md README.md )
PATCHES=(
	"${FILESDIR}/keras-2.14.0-0001-bazel-Use-system-protobuf.patch"
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

	ebazel build //keras/tools/pip_package:build_pip_package
	ebazel shutdown

	local srcdir="${T}/src-${EPYTHON/./_}"
	mkdir -p "${srcdir}" || die
	bazel-bin/keras/tools/pip_package/build_pip_package --src "${srcdir}" || die

	popd || die
}

src_compile() {
	export JAVA_HOME=$(java-config --jre-home)
	distutils-r1_src_compile
}

python_install() {
	pushd "${T}/src-${EPYTHON/./_}" >/dev/null || die
	esetup.py install
	python_optimize
	popd || die
}
