# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"

inherit multilib python

DESCRIPTION="CrossTeX - object oriented BibTeX replacement"
HOMEPAGE="http://www.cs.cornell.edu/people/egs/crosstex/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="dev-python/ply"
DEPEND="${RDEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_install() {
	emake \
		ROOT="${D}" \
		PREFIX="/usr" \
		LIBDIR="/$(get_libdir)/python$(python_get_version)/site-packages" \
		install || die "emake install failed"

	python_convert_shebangs -r $(python_get_version) "${D}"
	python_need_rebuild

	insinto /usr/share/doc/${PF}
	doins "${PN}".pdf
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins tests/*
	fi
}

pkg_postinst() {
	python_mod_optimize ${PN}
}

pkg_postrm() {
	python_mod_cleanup ${PN}
}
