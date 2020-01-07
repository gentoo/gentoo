# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="xml(+),threads(+)"
inherit distutils-r1 multilib

DESCRIPTION="Daemon part of Canto-NG RSS reader"
HOMEPAGE="https://codezen.org/canto-ng/"
SRC_URI="https://codezen.org/static/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/feedparser[${PYTHON_USEDEP}]"

S="${WORKDIR}/canto-next-${PV}"

python_prepare_all() {
	# Respect libdir during plugins installation
	sed -i -e "s:lib/canto:$(get_libdir)/canto:" setup.py || die

	distutils-r1_python_prepare_all
}
