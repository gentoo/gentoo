# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"

inherit distutils-r1

DESCRIPTION="A backup program that supports encryption and deduplication"
HOMEPAGE="http://obnam.org/"
SRC_URI="http://git.liw.fi/cgi-bin/cgit/cgit.cgi/obnam/snapshot/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="${PYTHON_DEPS}
	dev-python/cliapp[${PYTHON_USEDEP}]
	dev-python/fuse-python[${PYTHON_USEDEP}]
	dev-python/larch[${PYTHON_USEDEP}]
	dev-python/paramiko[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/tracing[${PYTHON_USEDEP}]
	dev-python/ttystatus[${PYTHON_USEDEP}]
	"
RDEPEND="${DEPEND}"

src_compile() {
	addwrite /proc/self/comm
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
	find "${D}" -name "obnam-viewprof*" -delete
	insinto /etc
	doins "${FILESDIR}"/obnam.conf
	keepdir /var/log/obnam
}
