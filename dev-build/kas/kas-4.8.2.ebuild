# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 optfeature

DESCRIPTION="Setup tool for bitbake based projects"
HOMEPAGE="
	https://github.com/siemens/kas
	https://kas.readthedocs.io/en/latest/
	https://pypi.org/project/kas/
"
# pypi does not package tests
SRC_URI="
	https://github.com/siemens/kas/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/pyyaml-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/distro-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/kconfiglib-14.1.0[${PYTHON_USEDEP}]
	>=dev-python/gitpython-3.1.0[${PYTHON_USEDEP}]
	dev-libs/newt[${PYTHON_USEDEP}]
"

BDEPEND="
	${RDEPEND}
	test? (
		dev-python/python-gnupg[${PYTHON_USEDEP}]
		dev-vcs/git
		dev-vcs/mercurial
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	"tests/test_build.py::test_provenance"
	"tests/test_commands.py::test_for_all_repos"
	"tests/test_commands.py::test_checkout_with_ci_rewrite"
	"tests/test_commands.py::test_checkout_create_refs[noenv]"
	"tests/test_commands.py::test_checkout_shallow[noenv]"
	"tests/test_commands.py::test_checkout[noenv]"
	"tests/test_commands.py::test_repo_includes[noenv]"
	"tests/test_commands.py::test_repo_includes"
	"tests/test_commands.py::test_shallow_updates[noenv]"
	"tests/test_refspec.py::test_refspec_switch[noenv]"
	"tests/test_refspec.py::test_refspec_absolute[noenv]"
	"tests/test_refspec.py::test_tag_commit_do_not_match[noenv] "
	"tests/test_refspec.py::test_unsafe_tag_warning[noenv]"
	"tests/test_refspec.py::test_tag_branch_same_name[noenv]"
	"tests/test_refspec.py::test_refspec_warning[noenv]"
	"tests/test_refspec.py::test_branch_and_tag[noenv]"
	"tests/test_refspec.py::test_commit_expand[noenv]"
	"tests/test_refspec.py::test_tag_commit_do_not_match[noenv]"
	"tests/test_signature_verify.py::test_signed_gpg_invalid[noenv]"
	"tests/test_signature_verify.py::test_signed_gpg_remove_key[noenv]"
	"tests/test_signature_verify.py::test_signed_gpg_local_key"
	"tests/test_commands.py::test_dump[noenv]"
	"tests/test_commands.py::test_diff"
	"tests/test_commands.py::test_lockfile"
	"tests/test_environment_variables.py::test_env_section_export_bb_extra_white"
	"tests/test_environment_variables.py::test_env_section_export_bb_env_passthrough_additions"
	"tests/test_environment_variables.py::test_ssh_agent_setup"
)

EPYTEST_IGNORE=(
	"tests/test_layers.py"
	"tests/test_menu.py"
	"tests/test_patch.py"
)

pkg_postinst() {
	optfeature_header "Install optional tools to clone repositories:"
	optfeature "git repository support" dev-vcs/git
	optfeature "mercurial repository support" dev-vcs/mercurial
}
