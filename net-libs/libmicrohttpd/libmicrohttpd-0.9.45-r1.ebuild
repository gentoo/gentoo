# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

MY_P="${P/_/}"

DESCRIPTION="Small C library to run an HTTP server as part of another application"
HOMEPAGE="https://www.gnu.org/software/libmicrohttpd/"
SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/11"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="epoll messages ssl static-libs test"

RDEPEND="ssl? (
		dev-libs/libgcrypt:0=
		net-libs/gnutls
	)"

# We disable tests below because they're broken,
# but if enabled, we'll need this.
DEPEND="${RDEPEND}
	test?	(
		ssl? ( net-misc/curl[ssl] )
	)"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS NEWS README ChangeLog"

src_configure() {
	econf \
		--enable-bauth \
		--enable-dauth \
		--disable-examples \
		--disable-spdy \
		--enable-postprocessor \
		--runstatedir=/run \
		$(use_enable epoll) \
		$(use_enable test curl) \
		$(use_enable messages) \
		$(use_enable ssl https) \
		$(use_with ssl gnutls) \
		$(use_enable static-libs static)
}

# tests are broken in the portage environment.
src_test() {
	:
}

src_install() {
	default

	use static-libs || find "${ED}" -name '*.la' -delete
}
