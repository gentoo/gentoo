# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Model-driven deployment, config management, and command execution framework"
HOMEPAGE="https://www.ansible.com/"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86 ~x64-macos"
RESTRICT="test"

RDEPEND=">=app-admin/ansible-core-2.14.0
	<app-admin/ansible-core-2.15"

python_compile() {
	local -x ANSIBLE_SKIP_CONFLICT_CHECK=1
	distutils-r1_python_compile
}
python_install() {
	local -x ANSIBLE_SKIP_CONFLICT_CHECK=1
	distutils-r1_python_install
}
