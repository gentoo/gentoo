# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/wraeth/kcheck"
	inherit git-r3
else
	SRC_URI="https://github.com/wraeth/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Record and check required kernel symbols are set"
HOMEPAGE="https://github.com/wraeth/kcheck"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-python/ConfigArgParse[${PYTHON_USEDEP}]
	sys-apps/portage[${PYTHON_USEDEP}]"

src_install() {
	distutils-r1_src_install
	mkdir "${D}"/etc || die
	mv -v "${D}"/{usr/,}etc/kcheck.conf || die
	rmdir -v "${D}"/usr/etc || die
}
