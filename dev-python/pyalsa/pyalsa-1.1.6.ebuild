# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} pypy )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Python bindings for ALSA library"
HOMEPAGE="https://alsa-project.org/"
SRC_URI="mirror://alsaproject/pyalsa/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="media-libs/alsa-lib"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}/${PN}-1.1.6-no-build-symlinks.patch" )

# Testsuite appears to require installed state
