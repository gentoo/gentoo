# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Generic Online Banking Interface"
HOMEPAGE="https://www.aquamaniac.de/sites/aqbanking/index.php"
SRC_URI="https://www.aquamaniac.de/rdm/attachments/download/467/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="debug doc ebics examples ofx"

BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"
DEPEND="
	app-misc/ktoblzcheck
	dev-libs/gmp:0=
	>=sys-libs/gwenhywfar-5.10.1:=
	virtual/libintl
	ebics? ( dev-libs/xmlsec:=[gcrypt] )
	ofx? ( >=dev-libs/libofx-0.9.5:= )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_configure() {
	local backends="aqhbci aqnone aqpaypal"
	use ofx && backends="${backends} aqofxconnect"
	use ebics && backends="${backends} aqebics"

	local myeconfargs=(
		--docdir="${EPREFIX}"/usr/share/doc/"${PF}"
		$(use_enable debug)
		$(use_enable doc full-doc)
		--with-backends="${backends}"
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	rm -rv "${ED}"/usr/share/doc/ || die "Failed to remove docs"

	einstalldocs

	if use examples; then
		docinto tutorials
		dodoc tutorials/*.{c,h} tutorials/README
	fi

	find "${D}" -name '*.la' -type f -delete || die
}
