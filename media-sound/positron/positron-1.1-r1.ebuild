# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Synchronization manager for the Neuros Audio Computer"
HOMEPAGE="https://www.xiph.org/positron"
SRC_URI="https://www.xiph.org/positron/files/source/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="vorbis"

DEPEND="vorbis? ( dev-python/pyvorbis[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"

python_prepare_all() {
	# install docs in /usr/share/doc/${PF}, bug #241290
	sed -i -e "s:share/doc/positron:share/doc/${PF}:" setup.py
	distutils-r1_python_prepare_all
}
