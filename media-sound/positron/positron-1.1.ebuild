# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"

inherit distutils

DESCRIPTION="Synchronization manager for the Neuros Audio Computer (www.neurosaudio.com) portable music player"
HOMEPAGE="http://www.xiph.org/positron"
SRC_URI="http://www.xiph.org/positron/files/source/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ppc sparc amd64"
IUSE="vorbis"

DEPEND="vorbis? ( dev-python/pyvorbis )"
RDEPEND="${DEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	distutils_src_prepare
	# install docs in /usr/share/doc/${PF}, bug #241290
	sed -i -e "s:share/doc/positron:share/doc/${PF}:" setup.py
}
