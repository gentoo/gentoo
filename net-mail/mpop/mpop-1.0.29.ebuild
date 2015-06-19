# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/mpop/mpop-1.0.29.ebuild,v 1.2 2015/04/08 18:18:33 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="A small, fast, and portable POP3 client"
HOMEPAGE="http://mpop.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome-keyring gnutls idn nls sasl ssl vim-syntax"
REQUIRED_USE="gnome-keyring? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	gnome-keyring? (
		${PYTHON_DEPS}
		dev-python/gnome-keyring-python
		gnome-base/libgnome-keyring
	)
	idn? ( net-dns/libidn )
	nls? ( virtual/libintl )
	sasl? ( virtual/gsasl )
	ssl? (
		gnutls? ( net-libs/gnutls )
		!gnutls? ( dev-libs/openssl )
	)"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig"

REQUIRED_USE="gnutls? ( ssl )"

DOCS="AUTHORS ChangeLog NEWS NOTES README THANKS"

src_configure() {
	econf \
		$(use_with gnome-keyring ) \
		$(use_with idn libidn) \
		$(use_enable nls) \
		$(use_with sasl libgsasl) \
		$(use_with ssl ssl $(usex gnutls "gnutls" "openssl"))
}

src_install() {
	default

	if use gnome-keyring ; then
		src_install_contrib mpop-gnome-tool mpop-gnome-tool.py README
		python_fix_shebang "${D}"/usr/share/${PN}/mpop-gnome-tool/mpop-gnome-tool.py
	fi

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/syntax
		doins scripts/vim/mpop.vim
	fi
}

src_install_contrib() {
	subdir="$1"
	bins="$2"
	docs="$3"
	local dir=/usr/share/${PN}/$subdir
	insinto ${dir}
	exeinto ${dir}
	for i in $bins ; do
		doexe scripts/$subdir/$i
	done
	for i in $docs ; do
		newdoc scripts/$subdir/$i $subdir.$i
	done
}
