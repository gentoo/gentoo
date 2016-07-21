# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit eutils python-r1

DESCRIPTION="Fast-paced, 3D, first-person shoot/dodge-'em-up, in the vain of Tempest or n2o"
HOMEPAGE="http://accelerator3d.sourceforge.net/"
SRC_URI="mirror://sourceforge/accelerator3d/accelerator-${PV}.tar.bz2"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-python/pygame[${PYTHON_USEDEP}]
	dev-python/pyode[${PYTHON_USEDEP}]
	dev-python/pyopengl[${PYTHON_USEDEP}]"

S=${WORKDIR}/${PN}

PATCHES=(
	"${FILESDIR}"/${P}-gentoo-paths.patch
	"${FILESDIR}"/${P}-gllightmodel.patch
)

src_prepare() {
	default

	sed -i \
		-e "s:@GENTOO_DATADIR@:/usr/share/${PN}:" \
		accelerator.py || die
}

src_install() {
	python_foreach_impl python_newscript accelerator.py accelerator
	insinto "/usr/share/${PN}"
	doins gfx/* snd/*
	dodoc CHANGELOG README
	make_desktop_entry accelerator
}
