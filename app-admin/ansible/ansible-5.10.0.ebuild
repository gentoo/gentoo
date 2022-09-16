# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Model-driven deployment, config management, and command execution framework"
HOMEPAGE="https://www.ansible.com/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86 ~x64-macos"
RESTRICT="test"

RDEPEND=">=app-admin/ansible-core-2.12.0
	<app-admin/ansible-core-2.13"

python_compile() {
	local -x ANSIBLE_SKIP_CONFLICT_CHECK=1
	distutils-r1_python_compile
}
python_install() {
	local -x ANSIBLE_SKIP_CONFLICT_CHECK=1
	distutils-r1_python_install
}
