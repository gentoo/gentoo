# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Python bindings for ALSA library"
HOMEPAGE="https://alsa-project.org/wiki/Main_Page"
SRC_URI="https://www.alsa-project.org/files/pub/pyalsa/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

RDEPEND="media-libs/alsa-lib"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}/${PN}-1.1.6-no-build-symlinks.patch" )

# Testsuite appears to require installed state
