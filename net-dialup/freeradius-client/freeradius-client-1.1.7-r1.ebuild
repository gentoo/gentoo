# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="FreeRADIUS Client framework"
HOMEPAGE="https://wiki.freeradius.org/project/Radiusclient"
SRC_URI="ftp://ftp.freeradius.org/pub/freeradius/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86"

IUSE="scp shadow static-libs"

DEPEND="!net-dialup/radiusclient-ng"
RDEPEND="${DEPEND}"

DOCS=(
	BUGS doc/{ChangeLog,login.example,release-method.txt,instop.html}
	README.{radexample,rst}
)

PATCHES=(
	"${FILESDIR}/${PN}-1.1.7-ar-configure.in.patch"
)

src_prepare() {
	default
	mv configure.in configure.ac || die \
		"Renaming configure.in to configure.ac failed"

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable scp)
		$(use_enable shadow)
		--with-secure-path
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	newdoc doc/README README.login.example

	use static-libs || \
		find "${ED}" -name '*.a' -delete
}
