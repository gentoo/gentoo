# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Useful set of performance and usability-oriented extensions to C"
HOMEPAGE="https://github.com/atheme/libmowgli-2"
EGIT_REPO_URI="https://github.com/atheme/libmowgli-2.git"

LICENSE="BSD-2"
SLOT="2"
KEYWORDS=""
IUSE="libressl ssl"

RDEPEND="
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README doc/BOOST doc/design-concepts.txt )

src_configure() {
	econf \
		$(use_with ssl openssl)
}
