# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE="ssl(+)"

inherit bash-completion-r1 distutils-r1

DESCRIPTION="Modern command line HTTP client"
HOMEPAGE="https://httpie.org/ https://pypi.org/project/httpie/"
SRC_URI="https://github.com/jakubroztocil/httpie/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/requests-2.22.0[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-0.9.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/pytest-httpbin[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local skipped_tests=()

	skipped_tests+=(
		tests/test_uploads.py::test_chunked_json
		tests/test_uploads.py::test_chunked_form
		tests/test_uploads.py::test_chunked_stdin
		tests/test_uploads.py::TestMultipartFormDataFileUpload::test_multipart_chunked
		tests/test_uploads.py::TestRequestBodyFromFilePath::test_request_body_from_file_by_path_chunked
		tests/test_tokens.py::test_verbose_chunked
	)

	pytest -v ${skipped_tests[@]/#/--deselect } || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	newbashcomp extras/httpie-completion.bash http
	insinto /usr/share/fish/vendor_completions.d
	newins extras/httpie-completion.fish http.fish
	distutils-r1_python_install_all
}
