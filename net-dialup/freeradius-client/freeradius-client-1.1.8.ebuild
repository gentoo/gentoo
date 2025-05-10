# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="FreeRADIUS Client framework"
HOMEPAGE="https://wiki.freeradius.org/project/Radiusclient"
SRC_URI="https://github.com/FreeRADIUS/freeradius-client/archive/refs/tags/release_${PV//[.]/_}.tar.gz -> ${PF}.tar.gz"

S="${WORKDIR}/${PN}-release_${PV//[.]/_}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="shadow static-libs"

DEPEND="
	!net-dialup/radiusclient-ng
	virtual/libcrypt:=
"
RDEPEND="${DEPEND}"

DOCS=(
	BUGS doc/{ChangeLog,login.example,release-method.txt,instop.html}
	README.{radexample,rst}
)

PATCHES=(
	"${FILESDIR}/${PN}-1.1.7-ar-configure.in.patch"
	"${FILESDIR}/${PN}-1.1.7-configure-clang16.patch"
)

src_prepare() {
	default
	mv configure.in configure.ac || die \
		"Renaming configure.in to configure.ac failed"

	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/927175
	# https://github.com/FreeRADIUS/freeradius-client/issues/128
	filter-lto

	local myeconfargs=(
		$(use_enable shadow)
		--with-secure-path
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	newdoc doc/README README.login.example

	use static-libs || \
		find "${ED}" \( -name '*.a' -o name '*.la' \) -delete
}
