# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit eutils

DESCRIPTION="exports a gssapi interface which calls other random gssapi libraries"
HOMEPAGE="http://www.citi.umich.edu/projects/nfsv4/linux/"
SRC_URI="http://www.citi.umich.edu/projects/nfsv4/linux/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND="!app-crypt/libgssapi"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-0.3-protos.patch \
		"${FILESDIR}"/${PN}-0.4-implicit-declarations.patch
}

src_configure() {
	# No need to install static libraries, as it uses libdl
	econf --disable-static
}

src_install() {
	default
	prune_libtool_files

	insinto /etc
	doins doc/gssapi_mech.conf
}
