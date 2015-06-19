# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/robodoc/robodoc-4.99.36.ebuild,v 1.2 2014/01/17 18:50:27 creffett Exp $

EAPI=5

DESCRIPTION="Automating Software Documentation"
HOMEPAGE="http://www.xs4all.nl/~rfsber/Robo/robodoc.html"
SRC_URI="http://www.xs4all.nl/~rfsber/Robo/DistSource/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND=">=dev-util/ctags-5.3.1"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	insinto /usr/share/${PN}
	doins Contributions/* || die "doins failed"

	rm -f "${D}"/usr/share/doc/${PF}/{COPYING,INSTALL}

	if use examples; then
		insinto /usr/share/${PN}
		doins -r Examples/PerlExample || die "doins failed"
	fi
}
