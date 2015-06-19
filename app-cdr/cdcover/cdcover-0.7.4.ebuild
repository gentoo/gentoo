# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdcover/cdcover-0.7.4.ebuild,v 1.1 2011/02/11 19:58:58 ssuominen Exp $

EAPI=2

PYTHON_DEPEND=2
PYTHON_USE_WITH=tk

inherit eutils python

DESCRIPTION="cdcover allows the creation of inlay-sheets for jewel cd-cases"
HOMEPAGE="http://cdcover.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cddb"

RDEPEND="cddb? ( dev-python/cddb-py )
	media-sound/cd-discid"
DEPEND=""

S=${WORKDIR}/${PN}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-Makefile.patch
	sed -i -e 's:ggv:gv:' dotcdcover.{example,m4} || die
}

src_compile() {
	emake prefix="${D}"/usr target=/usr || die
}

src_install() {
	emake prefix="${D}"/usr docdir="${D}"/usr/share/doc/${PF} install || die

	python_convert_shebangs -r 2 "${D}"

	make_desktop_entry ${PN} ${PN}

	insinto /usr/share/doc/${PF}/pdf
	doins doc/cdcover.pdf

	prepalldocs
}
