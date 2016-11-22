# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-2

DESCRIPTION="Useful set of performance and usability-oriented extensions to C"
HOMEPAGE="http://www.atheme.org/project/mowgli"
EGIT_REPO_URI="git://github.com/atheme/libmowgli-2.git"
IUSE="libressl ssl"

LICENSE="BSD-2"
SLOT="2"
KEYWORDS=""
RDEPEND="ssl? (
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
)"
DEPEND="${RDEPEND}"
DOCS="AUTHORS README doc/BOOST doc/design-concepts.txt"

src_configure() {
	    # disabling SSL is "broken" in 2.0.0 so we have to use this hack till 2.0.1
		use !ssl && myconf="--with-openssl=/dev/null"
		econf ${myconf}
}
