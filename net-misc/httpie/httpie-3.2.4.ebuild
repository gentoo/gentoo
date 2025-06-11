# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="ssl(+)"
DISTUTILS_USE_PEP517=setuptools

inherit bash-completion-r1 distutils-r1

DESCRIPTION="Modern command line HTTP client"
HOMEPAGE="https://httpie.io/ https://pypi.org/project/httpie/"
SRC_URI="https://github.com/httpie/cli/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"/cli-${PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-python/charset-normalizer[${PYTHON_USEDEP}]
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/multidict[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	>=dev-python/requests-2.22.0[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-0.9.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/pytest-httpbin[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# https://github.com/httpie/cli/issues/1530
	tests/test_compress.py::test_compress_form
	tests/test_binary.py::TestBinaryResponseData

	# https://github.com/httpie/cli/issues/1628
	tests/test_encoding.py::test_terminal_output_response_charset_detection
	tests/test_encoding.py::test_terminal_output_request_charset_detection

	# argparse change in >=py3.12 (bug #949484)
	tests/test_cli_ui.py::test_naked_invocation

	# Fails with py3.14
	tests/test_cli_utils.py::test_lazy_choices_help

	# Needs network
	'tests/test_cookie_on_redirects.py::test_explicit_user_set_cookie_in_session[remote_httpbin]'
	'tests/test_cookie_on_redirects.py::test_explicit_user_set_cookie[remote_httpbin]'
	'tests/test_cookie_on_redirects.py::test_explicit_user_set_headers[False-remote_httpbin]'
	'tests/test_cookie_on_redirects.py::test_explicit_user_set_headers[True-remote_httpbin]'
	tests/test_cookie_on_redirects.py::test_saved_session_cookie_pool
	tests/test_cookie_on_redirects.py::test_saved_session_cookies_on_different_domain
	'tests/test_cookie_on_redirects.py::test_saved_session_cookies_on_redirect[httpbin-httpbin-remote_httpbin-False]'
	'tests/test_cookie_on_redirects.py::test_saved_session_cookies_on_redirect[httpbin-remote_httpbin-httpbin-True]'
	'tests/test_cookie_on_redirects.py::test_saved_session_cookies_on_redirect[httpbin-remote_httpbin-remote_httpbin-False]'
	'tests/test_cookie_on_redirects.py::test_saved_user_set_cookie_in_session[remote_httpbin]'
	'tests/test_sessions.py::test_secure_cookies_on_localhost[remote_httpbin-expected_cookies1]'
	tests/test_tokens.py::test_verbose_chunked
	tests/test_uploads.py::test_chunked_form
	tests/test_uploads.py::test_chunked_json
	tests/test_uploads.py::test_chunked_raw
	tests/test_uploads.py::test_chunked_stdin
	tests/test_uploads.py::test_chunked_stdin_multiple_chunks
	tests/test_uploads.py::TestMultipartFormDataFileUpload::test_multipart_chunked
	tests/test_uploads.py::TestRequestBodyFromFilePath::test_request_body_from_file_by_path_chunked
)

EPYTEST_IGNORE=(
	# Assumes installation in a clean venv
	tests/test_plugins_cli.py
)

distutils_enable_tests pytest

python_install_all() {
	newbashcomp extras/httpie-completion.bash http
	insinto /usr/share/fish/vendor_completions.d
	newins extras/httpie-completion.fish http.fish
	distutils-r1_python_install_all
}
