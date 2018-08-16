# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${P/_beta/beta}"
DESCRIPTION="Generic Online Banking Interface"
HOMEPAGE="https://www.aquamaniac.de/aqbanking/"
SRC_URI="https://www.aquamaniac.de/sites/download/download.php?package=03&release=217&file=02&dummy=${MY_P}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="chipcard debug doc ebics examples gtk ofx"

RDEPEND="
	app-misc/ktoblzcheck
	dev-libs/gmp:0=
	sys-libs/gwenhywfar:=[gtk?]
	virtual/libintl
	chipcard? ( >=sys-libs/libchipcard-5.0.2 )
	ebics? ( dev-libs/xmlsec[gcrypt,gnutls] )
	ofx? ( >=dev-libs/libofx-0.9.5 )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

MAKEOPTS="${MAKEOPTS} -j1" # 5.7.8 still fails with > -j1

S="${WORKDIR}/${MY_P}"

src_configure() {
	local backends="aqhbci aqnone aqpaypal"
	use ofx && backends="${backends} aqofxconnect"
	use ebics && backends="${backends} aqebics"

	local mytest
	use gtk && mytest="--enable-gui-tests"

	econf \
		$(use_enable debug) \
		$(use_enable doc full-doc) \
		--with-backends="${backends}" \
		--with-docpath=/usr/share/doc/${PF}/apidoc \
		${mytest}
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
