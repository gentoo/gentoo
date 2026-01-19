# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P//_/}"

DESCRIPTION="Generic Online Banking Interface"
HOMEPAGE="https://www.aquamaniac.de/sites/aqbanking/index.php"
SRC_URI="https://www.aquamaniac.de/rdm/attachments/download/652/${MY_P}.tar.gz"

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="debug doc ebics examples ofx"

DEPEND="
	app-misc/ktoblzcheck
	dev-libs/gmp:0=
	>=sys-libs/gwenhywfar-5.14.1:=
	virtual/libintl
	ebics? ( dev-libs/xmlsec:=[gcrypt] )
	ofx? ( >=dev-libs/libofx-0.9.5:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_configure() {
	local backends="aqhbci aqnone aqpaypal"
	use ebics && backends="${backends} aqebics"
	use ofx && backends="${backends} aqofxconnect"

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
