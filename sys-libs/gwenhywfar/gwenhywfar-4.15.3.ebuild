# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P="${P/_beta/beta}"
DESCRIPTION="A multi-platform helper library for other libraries"
HOMEPAGE="http://www.aquamaniac.de/aqbanking/"
SRC_URI="http://www.aquamaniac.de/sites/download/download.php?package=01&release=201&file=01&dummy=${MY_P}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug doc fox gtk qt4"

RDEPEND="dev-libs/libgpg-error
	>=dev-libs/libgcrypt-1.2.0:0
	dev-libs/openssl:0
	>=net-libs/gnutls-2.0.1
	virtual/libiconv
	virtual/libintl
	fox? ( x11-libs/fox:1.6 )
	gtk? ( >=x11-libs/gtk+-2.17.5:2 )
	qt4? ( dev-qt/qtgui:4 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
	doc? ( app-doc/doxygen )"

# broken upstream, reported but got no reply
RESTRICT="test"

src_configure() {
	local guis
	use fox && guis="${guis} fox16"
	use gtk && guis="${guis} gtk2"
	use qt4 && guis="${guis} qt4"

	econf \
		--enable-ssl \
		--enable-visibility \
		$(use_enable debug) \
		$(use_enable doc full-doc) \
		--with-guis="${guis}" \
		--with-docpath=/usr/share/doc/${PF}/apidoc
}

src_compile() {
	emake
	use doc && emake srcdoc
}

src_install() {
	emake DESTDIR="${D}" install
	use doc && emake DESTDIR="${D}" install-srcdoc
	dodoc AUTHORS ChangeLog README TODO
	find "${ED}" -name '*.la' -exec rm -f {} +
}
