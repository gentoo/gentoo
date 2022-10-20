# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit multilib-minimal

MY_P="${P/_/}"

DESCRIPTION="Small C library to run an HTTP server as part of another application"
HOMEPAGE="https://www.gnu.org/software/libmicrohttpd/"
SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/12"
KEYWORDS="amd64 x86"
IUSE="+epoll ssl static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="ssl? ( >net-libs/gnutls-2.12.20:=[${MULTILIB_USEDEP}] )"

# We disable tests below because they're broken,
# but if enabled, we'll need this.
DEPEND="${RDEPEND}
	test?	( net-misc/curl[ssl?] )"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS NEWS README ChangeLog"

PATCHES=( "${FILESDIR}"/${PN}-0.9.73-test-ssl3.patch )

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf \
		--enable-bauth \
		--enable-dauth \
		--disable-examples \
		--enable-messages \
		--enable-postprocessor \
		--disable-thread-names \
		$(use_enable epoll) \
		$(use_enable test curl) \
		$(use_enable ssl https) \
		$(use_with ssl gnutls) \
		$(use_enable static-libs static)
}

# tests are broken in the portage environment.
src_test() {
	:
}

multilib_src_install_all() {
	default

	use static-libs || find "${ED}" -name '*.la' -delete
}
