# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils libtool

DESCRIPTION="library that handles Resource Description Framework (RDF)"
HOMEPAGE="http://librdf.org/rasqal/"
SRC_URI="http://download.librdf.org/source/${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos"
IUSE="+crypt gmp kernel_linux +mhash pcre static-libs test xml"

RDEPEND=">=media-libs/raptor-2.0.14
	kernel_linux? ( >=sys-apps/util-linux-2.19 )
	pcre? ( dev-libs/libpcre )
	xml? ( dev-libs/libxml2 )
	!gmp? ( dev-libs/mpfr )
	gmp? ( dev-libs/gmp )
	crypt? (
		!mhash? ( dev-libs/libgcrypt:0 )
		mhash? ( app-crypt/mhash )
	)"
DEPEND="${RDEPEND}
	>=sys-devel/bison-3
	>=sys-devel/flex-2.5.36
	virtual/pkgconfig
	test? ( dev-perl/XML-DOM )"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	elibtoolize # g/fbsd .so versioning
}

src_configure() {
	# FIXME: From 0.9.27 to .28 --with-random-approach= was introduced, do we
	# need a logic for it? Perhaps for dev-libs/gmp?

	local regex=posix
	local decimal=mpfr
	local digest=internal
	local uuid=internal

	use pcre && regex=pcre
	use gmp && decimal=gmp
	use kernel_linux && uuid=libuuid

	if use crypt; then
		digest=gcrypt
		use mhash && digest=mhash
	fi

	econf \
		$(use_enable pcre) \
		$(use_enable static-libs static) \
		$(use_enable xml xml2) \
		--with-regex-library=${regex} \
		--with-digest-library=${digest} \
		--with-uuid-library=${uuid} \
		--with-decimal=${decimal} \
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF}/html
}

src_install() {
	default
	dohtml {NEWS,README,RELEASE}.html
	prune_libtool_files --all

	# https://bugs.gentoo.org/467768
	local _rdocdir=/usr/share/doc/${PF}/html/${PN}
	[[ -d ${ED}/${_rdocdir} ]] && dosym ${_rdocdir} /usr/share/gtk-doc/html/${PN}
}
