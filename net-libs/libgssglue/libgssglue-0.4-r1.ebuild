# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Exports a gssapi interface which calls other random gssapi libraries"
HOMEPAGE="http://www.citi.umich.edu/projects/nfsv4/linux/"
SRC_URI="http://www.citi.umich.edu/projects/nfsv4/linux/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86"
IUSE=""

RDEPEND="!app-crypt/libgssapi"
DEPEND=""

PATCHES=(
	"${FILESDIR}"/${PN}-0.3-protos.patch
	"${FILESDIR}"/${PN}-0.4-implicit-declarations.patch
)

src_prepare() {
	default
	sed -i -e "s,/lib/,/$(get_libdir)/," doc/gssapi_mech.conf #646126
}

src_configure() {
	# No need to install static libraries, as it uses libdl
	econf --disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die

	insinto /etc
	doins doc/gssapi_mech.conf
}
