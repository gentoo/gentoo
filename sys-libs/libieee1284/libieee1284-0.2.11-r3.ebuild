# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

PYTHON_DEPEND="python? 2"
inherit eutils python multilib-minimal

DESCRIPTION="Library to query devices using IEEE1284"
HOMEPAGE="http://cyberelk.net/tim/libieee1284/index.html"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE="doc python static-libs"

RDEPEND="abi_x86_32? ( !<=app-emulation/emul-linux-x86-medialibs-20130224-r9
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}
	doc? (
		app-text/docbook-sgml-utils
		>=app-text/docbook-sgml-dtd-4.1
		app-text/docbook-dsssl-stylesheets
		dev-perl/XML-RegExp
	)"

DOCS="AUTHORS NEWS README* TODO doc/interface*"

pkg_setup() {
	use python && python_set_active_version 2
}

multilib_src_configure() {
	local myconf="--without-python"
	multilib_is_native_abi && myconf="$(use_with python)"

	ECONF_SOURCE="${S}" econf \
		--enable-shared \
		$(use_enable static-libs static) \
		${myconf}
}

multilib_src_install_all() {
	prune_libtool_files --all
	einstalldocs
}
