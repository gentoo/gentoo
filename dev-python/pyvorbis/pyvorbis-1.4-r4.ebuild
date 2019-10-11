# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 toolchain-funcs

DESCRIPTION="Python bindings for the ogg.vorbis library"
HOMEPAGE="http://ekyo.nerim.net/software/pyogg/"
SRC_URI="http://ekyo.nerim.net/software/pyogg/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

DEPEND=">=dev-python/pyogg-1.1[${PYTHON_USEDEP}]
	>=media-libs/libogg-1.0
	>=media-libs/libvorbis-1.0"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS COPYING ChangeLog NEWS README )
PATCHES=(
	"${FILESDIR}/pyvorbisfile.c-1.4.patch"
	"${FILESDIR}/${P}-python25.patch"
)

python_configure_all() {
	tc-export CC
	"${PYTHON}" config_unix.py --prefix /usr || die "Configuration failed"
}

python_install_all() {
	distutils-r1_python_install_all
	insinto /usr/share/doc/${PF}/examples
	doins test/*
}
