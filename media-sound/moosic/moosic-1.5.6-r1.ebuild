# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit bash-completion-r1 distutils-r1

DESCRIPTION="Music player that focuses on easy playlist management"
HOMEPAGE="http://www.nanoo.org/~daniel/moosic"
SRC_URI="http://www.nanoo.org/~daniel/${PN}/${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE="doc"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -i -e 's:distutils.core:setuptools:' setup.py || die "sed failed"
	distutils-r1_python_prepare_all
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/*.html )

	distutils-r1_python_install_all

	rm -rf "${D}"/usr/share/doc/${PN}
	newbashcomp examples/completion ${PN}
	dodoc doc/{Moosic_API.txt,moosic_hackers.txt,Todo}
	dodoc examples/server_config
}
