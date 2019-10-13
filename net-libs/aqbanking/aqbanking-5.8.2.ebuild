# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Generic Online Banking Interface"
HOMEPAGE="https://www.aquamaniac.de/sites/aqbanking/index.php"
SRC_URI="https://www.aquamaniac.de/rdm/attachments/download/107/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug doc ebics examples ofx smartcard"

BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
RDEPEND="
	app-misc/ktoblzcheck
	dev-libs/gmp:0=
	>=sys-libs/gwenhywfar-4.20.2-r1:=
	virtual/libintl
	ebics? ( dev-libs/xmlsec[gcrypt,gnutls] )
	ofx? ( >=dev-libs/libofx-0.9.5 )
	smartcard? ( >=sys-libs/libchipcard-5.0.2 )
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

MAKEOPTS="${MAKEOPTS} -j1" # 5.7.8 still fails with > -j1

src_configure() {
	local backends="aqhbci aqnone aqpaypal"
	use ofx && backends="${backends} aqofxconnect"
	use ebics && backends="${backends} aqebics"

	econf \
		$(use_enable debug) \
		$(use_enable doc full-doc) \
		--with-backends="${backends}" \
		--with-docpath=/usr/share/doc/${PF}/apidoc
}

src_install() {
	emake DESTDIR="${D}" install

	rm -rv "${ED}"/usr/share/doc/ || die

	einstalldocs

	newdoc src/plugins/backends/aqhbci/tools/aqhbci-tool/README \
		README.aqhbci-tool

	if use examples; then
		docinto tutorials
		dodoc tutorials/*.{c,h} tutorials/README
	fi

	find "${ED}" -name '*.la' -delete || die
}
