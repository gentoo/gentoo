# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Exports a gssapi interface which calls other random gssapi libraries"
HOMEPAGE="http://www.citi.umich.edu/projects/nfsv4/linux https://gitlab.com/gsasl/libgssglue"
SRC_URI="https://gitlab.com/gsasl/libgssglue/-/archive/${P}/${PN}-${P}.tar.bz2"
S="${WORKDIR}"/${PN}-${P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3-protos.patch
	"${FILESDIR}"/${PN}-0.4-implicit-declarations.patch
)

src_prepare() {
	default

	# bug #646126
	sed -i -e "s,/lib/,/$(get_libdir)/," doc/gssapi_mech.conf || die

	eautoreconf
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	insinto /etc
	doins doc/gssapi_mech.conf
}
