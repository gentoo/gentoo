# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit git-2

DESCRIPTION="Useful set of performance and usability-oriented extensions to C"
HOMEPAGE="http://www.atheme.org/project/mowgli"
EGIT_REPO_URI="git://github.com/atheme/libmowgli-2.git"
IUSE="ssl"

LICENSE="BSD-2"
SLOT="2"
KEYWORDS=""
RDEPEND="ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}"
DOCS="AUTHORS README doc/BOOST doc/design-concepts.txt"

src_configure() {
	    # disabling SSL is "broken" in 2.0.0 so we have to use this hack till 2.0.1
		use !ssl && myconf="--with-openssl=/dev/null"
		econf ${myconf}
}
