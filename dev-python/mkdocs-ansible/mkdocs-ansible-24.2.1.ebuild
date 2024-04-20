# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Ansible theme for MkDocs"
HOMEPAGE="
	https://github.com/ansible/mkdocs-ansible/
	https://pypi.org/project/mkdocs-ansible/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	>=dev-python/markdown-exec-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/markdown-include-0.8.1[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-gen-files-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-htmlproofer-plugin-0.10.2[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-material-extensions-1.1.1[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-material-9.0.13[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-minify-plugin-0.6.2[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-monorepo-plugin-1.0.4[${PYTHON_USEDEP}]
	>=dev-python/mkdocs-1.4.2[${PYTHON_USEDEP}]
	>=dev-python/mkdocstrings-python-0.8.3[${PYTHON_USEDEP}]
	>=dev-python/mkdocstrings-0.21.2[${PYTHON_USEDEP}]
	>=dev-python/pillow-9.4.0[${PYTHON_USEDEP}]
	>=dev-python/pymdown-extensions-9.9.2[${PYTHON_USEDEP}]
	>=media-gfx/cairosvg-2.6.0[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${PN}-24.2.1-prune_deps.patch
)
