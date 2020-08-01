# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
PYTHON_REQ_USE="sqlite"
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Distributed C/C++ package manager"
HOMEPAGE="https://conan.io/"
SRC_URI="https://github.com/conan-io/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

# overly strict requirements?
# https://github.com/conan-io/conan/blob/develop/conans/requirements.txt
# https://github.com/conan-io/conan/blob/develop/conans/requirements_server.txt
RDEPEND="
	>=dev-python/bottle-0.12.8[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.3.3[${PYTHON_USEDEP}]
	>=dev-python/deprecation-2.0[${PYTHON_USEDEP}]
	>=dev-python/distro-1.0.2[${PYTHON_USEDEP}]
	>=dev-python/fasteners-0.14.1[${PYTHON_USEDEP}]
	>=dev-python/future-0.16.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.10.1[${PYTHON_USEDEP}]
	>=dev-python/node-semver-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/patch-ng-1.17.4[${PYTHON_USEDEP}]
	>=dev-python/pluginbase-0.5[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
	>=dev-python/pyjwt-1.4[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.7.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.8.1[${PYTHON_USEDEP}]
	>=dev-python/six-1.12.0[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.28.1[${PYTHON_USEDEP}]
"

distutils_enable_tests nose
DEPEND+="
	test? (
		dev-lang/go
		dev-vcs/git
		dev-vcs/subversion
		>=dev-python/mock-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/nose-1.3.7[${PYTHON_USEDEP}]
		>=dev-python/parameterized-0.6.3[${PYTHON_USEDEP}]
		>=dev-python/webtest-2.0.18[${PYTHON_USEDEP}]
		dev-util/cmake
	)
"

src_prepare() {
	default
	# Fix strict dependencies
	sed -i \
		-e "s:six>=1.10.0,<=1.14.0:six>=1.12.0:g" \
		-e "s:node-semver==0.6.1:node-semver>=0.6.1:g" \
		-e "s:distro>=1.0.2, <1.2.0:distro>=1.0.2:g" \
		conans/requirements.txt || die
}

python_test() {
	nosetests -v conans.test \
		-e test_ftp.* -e modify_values_test.* -e test_pkg_config_path.* \
		-e rpath_optin_test -e test_variables -e system_package_tool_installed_test \
		-e virtualbuildenv_test -e scm_test -e test_git_shallow -e tools_test \
		-e test_environment_nested -e devflow_test -e shared_chain_test \
		-e test_toolchain_linux_0_Debug -e test_toolchain_linux_1_Release \
		-e virtualenv_test \
		-A "not rest_api and not local_bottle" || die
}
