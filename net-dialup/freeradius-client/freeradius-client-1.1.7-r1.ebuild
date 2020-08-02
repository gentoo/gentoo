# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="FreeRADIUS Client framework"
HOMEPAGE="https://wiki.freeradius.org/project/Radiusclient"
SRC_URI="ftp://ftp.freeradius.org/pub/freeradius/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="scp shadow static-libs"

DEPEND="!net-dialup/radiusclient-ng"
RDEPEND="${DEPEND}"

DOCS=(
	BUGS doc/{ChangeLog,login.example,release-method.txt,instop.html}
	README.{radexample,rst}
)

src_prepare() {
	default
	mv configure.in configure.ac || die \
		"Renaming configure.in to configure.ac failed"
	eautoreconf
}

src_configure() {
	tc-export AR

	local myeconfargs=(
		$(use_enable scp)
		$(use_enable shadow)
		--with-secure-path
	)
	econf "${myeconfargs[@]}"

	for MAKEFILE in $(find -name Makefile) libtool; do
		sed -i "s|/usr/bin/ar|${AR}|" "${MAKEFILE}" || \
			die "Patching ${MAKEFILE} for ${AR} failed"
	done
}

src_install() {
	default
	newdoc doc/README README.login.example

	use static-libs || \
		find "${ED}" -name '*.a' -delete
}
