# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Unit conversion utility written in PyGTK"
HOMEPAGE="http://unihedron.com/projects/gonvert/index.php"
SRC_URI="http://unihedron.com/projects/gonvert/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/pygtk:2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/0.2.23-paths.patch )

src_install () {
	emake install DESTDIR="${D}" prefix="${EPREFIX}/usr"
	python_fix_shebang "${ED%/}"/usr/bin
	rm -fr "${ED%/}/usr/share/doc/${PN}" || die
	einstalldocs
}
