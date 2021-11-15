# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit bazel distutils-r1

DESCRIPTION="Deep Learning for humans"
HOMEPAGE="https://keras.io/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

bazel_external_uris="
	https://github.com/bazelbuild/rules_cc/archive/b1c40e1de81913a3c40e5948f78719c28152486d.zip -> bazelbuild-rules_cc-b1c40e1de81913a3c40e5948f78719c28152486d.zip
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
	>=sci-libs/keras-preprocessing-1.1.2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
BDEPEND="
	app-arch/unzip
	>=dev-libs/protobuf-3.13.0
	dev-java/java-config
	>=dev-util/bazel-3.7.2"
PDEPEND="sci-libs/tensorflow[python,${PYTHON_USEDEP}]"

# Bazel tests not pytest, also want GPU access
RESTRICT="test"
DOCS=( CONTRIBUTING.md README.md )
PATCHES=(
	"${FILESDIR}/keras-2.7.0-0001-bazel-Use-system-protobuf.patch"
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

src_compile() {
	export JAVA_HOME=$(java-config --jre-home)

	do_compile() {
		ebazel build //keras/tools/pip_package:build_pip_package
		ebazel shutdown

		local srcdir="${T}/src-${EPYTHON/./_}"
		mkdir -p "${srcdir}" || die
		bazel-bin/keras/tools/pip_package/build_pip_package --src "${srcdir}" || die
	}

	python_foreach_impl run_in_build_dir do_compile
}

src_install() {
	do_install() {
		cd "${T}/src-${EPYTHON/./_}" || die
		esetup.py install
		python_optimize
	}
	python_foreach_impl do_install

	cd "${S}" || die
	einstalldocs
}
