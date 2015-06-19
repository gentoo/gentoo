# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdcover/cdcover-0.7.4-r1.ebuild,v 1.1 2014/12/26 21:42:13 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE=tk

inherit eutils python-single-r1

DESCRIPTION="cdcover allows the creation of inlay-sheets for jewel cd-cases"
HOMEPAGE="http://cdcover.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cddb"

RDEPEND="${PYTHON_DEPS}
	cddb? ( dev-python/cddb-py[${PYTHON_USEDEP}] )
	media-sound/cd-discid"
DEPEND=""

REQUIRED_USE=${PYTHON_REQUIRED_USE}

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-Makefile.patch
	sed -i -e 's:ggv:gv:' dotcdcover.{example,m4} || die
}

src_compile() {
	emake prefix="${D}"/usr target=/usr || die
}

src_install() {
	emake prefix="${D}"/usr docdir="${D}"/usr/share/doc/${PF} install || die

	python_fix_shebang "${D}"

	make_desktop_entry ${PN} ${PN}

	dodoc doc/cdcover.pdf
}
