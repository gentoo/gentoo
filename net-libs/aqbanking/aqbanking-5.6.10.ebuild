# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

MY_P="${P/_beta/beta}"
DESCRIPTION="Generic Online Banking Interface"
HOMEPAGE="http://www.aquamaniac.de/aqbanking/"
SRC_URI="http://www.aquamaniac.de/sites/download/download.php?package=03&release=206&file=01&dummy=${MY_P}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="chipcard debug doc ebics examples gtk ofx"

RDEPEND=">=app-misc/ktoblzcheck-1.48
	>=dev-libs/gmp-5
	>=sys-libs/gwenhywfar-4.13.1[gtk?]
	virtual/libintl
	ofx? ( >=dev-libs/libofx-0.9.5 )
	chipcard? ( >=sys-libs/libchipcard-5.0.2 )
	ebics? ( dev-libs/xmlsec[gcrypt,gnutls] )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

MAKEOPTS="${MAKEOPTS} -j1" # 5.0.x fails with -j9 on quadcore

src_configure() {
	local backends="aqhbci aqnone"
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

	dodoc AUTHORS ChangeLog NEWS README TODO

	newdoc src/plugins/backends/aqhbci/tools/aqhbci-tool/README \
		README.aqhbci-tool

	if use examples; then
		docinto tutorials
		dodoc tutorials/*.{c,h} tutorials/README
	fi

	prune_libtool_files --all
}
