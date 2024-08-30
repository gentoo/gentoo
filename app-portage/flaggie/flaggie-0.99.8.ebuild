# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="A smart CLI mangler for package.* files"
HOMEPAGE="
	https://github.com/projg2/flaggie/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~mips ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=app-portage/gentoopm-0.5.0[${PYTHON_USEDEP}]
	dev-python/more-itertools[${PYTHON_USEDEP}]
	dev-vcs/git
"

distutils_enable_tests pytest

pkg_postinst() {
	ewarn "This is a preview release of flaggie 1.x. It it not fully featured"
	ewarn "yet and it may have significant bugs. Please back your /etc/portage"
	ewarn "up before using it. Verify the results using --pretend."
}
