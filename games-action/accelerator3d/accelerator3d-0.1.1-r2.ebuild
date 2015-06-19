# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/accelerator3d/accelerator3d-0.1.1-r2.ebuild,v 1.7 2015/03/21 15:10:44 nativemad Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils python-r1 games

DESCRIPTION="Fast-paced, 3D, first-person shoot/dodge-'em-up, in the vain of Tempest or n2o"
HOMEPAGE="http://accelerator3d.sourceforge.net/"
SRC_URI="mirror://sourceforge/accelerator3d/accelerator-${PV}.tar.bz2"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-python/pyode[${PYTHON_USEDEP}]
	dev-python/pygame[${PYTHON_USEDEP}]
	dev-python/pyopengl[${PYTHON_USEDEP}]"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gentoo-paths.patch \
		"${FILESDIR}"/${P}-gllightmodel.patch
	sed -i \
		-e "s:@GENTOO_DATADIR@:${GAMES_DATADIR}/${PN}:" \
		accelerator.py || die
}

src_install() {
	python_scriptinto "${GAMES_BINDIR}"
	python_foreach_impl python_newscript accelerator.py accelerator
	insinto "${GAMES_DATADIR}"/${PN}
	doins gfx/* snd/*
	dodoc CHANGELOG README
	make_desktop_entry accelerator

	prepgamesdirs
}
