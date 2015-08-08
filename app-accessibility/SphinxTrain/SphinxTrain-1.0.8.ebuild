# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit multilib python-single-r1

DESCRIPTION="Speech Recognition (Training Module)"
HOMEPAGE="http://cmusphinx.sourceforge.net/html/cmusphinx.php"
SRC_URI="mirror://sourceforge/cmusphinx/sphinxtrain-${PV}.tar.gz"

LICENSE="BSD-with-attribution"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="app-accessibility/sphinxbase
	dev-lang/perl
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/sphinxtrain-${PV}

src_install() {
	default
	dodoc README etc/*cfg

	python_fix_shebang "${D}"/usr/bin/sphinxtrain
	python_optimize "${D}"/usr/$(get_libdir)/sphinxtrain/python/cmusphinx
}

pkg_postinst() {
	elog "Detailed usage and training instructions can be found at"
	elog "http://cmusphinx.sourceforge.net/wiki/"
}
