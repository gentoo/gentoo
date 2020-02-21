# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Open Application Interface Specification cluster framework"
HOMEPAGE="http://www.openais.org/"
SRC_URI="ftp://ftp:${PN}.org@${PN}.org/downloads/${P}/${P}.tar.gz"

LICENSE="BSD public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm64 hppa x86"
IUSE="static-libs"

RDEPEND="<sys-cluster/corosync-2.0.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( "${S}/AUTHORS" "${S}/README.amf" )

src_prepare() {
	default

	# respect CFLAGS
	sed -i -e "s/\$OPT_CFLAGS \$GDB_FLAGS//" configure.ac || die
	# respect LDFLAGS
	sed -i -e "s/\$(CFLAGS) -shared/\$(CFLAGS) \$(LDFLAGS) -shared/" \
		services/Makefile.am || die
	# don't install docs
	sed -i -e "/^dist_doc/d" Makefile.am || die

	eautoreconf
}

src_configure() {
	econf \
		--localstatedir="${EPREFIX}"/var
}

src_install() {
	default

	rm -rf "${D}"/etc/init.d/openais || die

	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die "Pruning failed"
	fi
}
