# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Useful set of performance and usability-oriented extensions to C"
HOMEPAGE="http://atheme.org/projects/libmowgli.html"
EGIT_REPO_URI="https://github.com/atheme/libmowgli-2.git"
IUSE="libressl ssl"

LICENSE="BSD-2"
SLOT="2"
KEYWORDS=""
RDEPEND="ssl? (
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
)"
DEPEND="${RDEPEND}"
DOCS=( AUTHORS README doc/BOOST doc/design-concepts.txt )

src_configure() {
	econf \
		$(use_with ssl openssl)
}
