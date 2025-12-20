# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

# see DEFAULT_WAR_URL in tests/__init__.py
GERRIT_PV=3.4.4
DESCRIPTION="Tool to submit code to Gerrit"
HOMEPAGE="https://git.openstack.org/cgit/openstack-infra/git-review"
if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://opendev.org/opendev/${PN}.git"
else
	inherit pypi
	KEYWORDS="~amd64 ~x86"
fi
SRC_URI+="
	test? (
		https://gerrit-releases.storage.googleapis.com/gerrit-${GERRIT_PV}.war
	)
"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	>=dev-python/requests-1.1[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/pbr-4.1.0[${PYTHON_USEDEP}]
	test? (
		virtual/jre:*
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -i -e '/manpages/,+1d' setup.cfg || die

	if use test; then
		mkdir .gerrit || die
		cp "${DISTDIR}/gerrit-${GERRIT_PV}.war" .gerrit/ || die
	fi
}

python_test() {
	local EPYTEST_DESELECT=(
		# changed message in git
		git_review/tests/test_git_review.py::GitReviewTestCase::test_need_rebase_no_upload
		git_review/tests/test_git_review.py::HttpGitReviewTestCase::test_need_rebase_no_upload
		git_review/tests/test_git_review.py::PushUrlTestCase::test_need_rebase_no_upload
	)

	if [[ ! -d .gerrit/golden_site ]]; then
		"${EPYTHON}" -m git_review.tests.prepare || die
		git init || die
	fi
	epytest
}

python_install_all() {
	doman git-review.1

	distutils-r1_python_install_all
}
