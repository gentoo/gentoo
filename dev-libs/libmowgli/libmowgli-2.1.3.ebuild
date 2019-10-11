# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Useful set of performance and usability-oriented extensions to C"
HOMEPAGE="https://github.com/atheme/libmowgli-2"
SRC_URI="https://github.com/atheme/libmowgli-2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="2"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="libressl ssl"

RDEPEND="ssl? (
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	)
	!~dev-libs/libmowgli-2.1.0" # Bug 629644
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README doc/BOOST doc/design-concepts.txt )
S="${WORKDIR}/${PN}-2-${PV}"

src_configure() {
	econf \
		$(use_with ssl openssl)
}
