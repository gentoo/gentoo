# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Record and check required kernel symbols are set"
HOMEPAGE="https://github.com/wraeth/kcheck"
SRC_URI="https://github.com/wraeth/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/ConfigArgParse[${PYTHON_USEDEP}]
	sys-apps/portage[${PYTHON_USEDEP}]
"

src_install() {
	distutils-r1_src_install
	mkdir "${D}"/etc || die
	mv -v "${D}"/{usr/,}etc/kcheck.conf || die
	rmdir -v "${D}"/usr/etc || die
}
