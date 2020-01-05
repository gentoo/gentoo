# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit autotools python-any-r1

DESCRIPTION="An easy to use library for the RELP protocol"
HOMEPAGE="http://www.librelp.com/"
SRC_URI="http://download.rsyslog.com/${PN}/${P}.tar.gz"

LICENSE="GPL-3+ doc? ( FDL-1.3 )"

# subslot = soname version
SLOT="0/0.5.0"

KEYWORDS="amd64 arm ~arm64 hppa sparc x86"
IUSE="debug doc +ssl +gnutls libressl openssl static-libs test"
REQUIRED_USE="ssl? ( ^^ ( gnutls openssl ) )"

RDEPEND="
	ssl? (
		gnutls? ( >=net-libs/gnutls-3.3.17.1:0= )
		openssl? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:0= )
		)
	)"
DEPEND="${RDEPEND}
	test? ( ${PYTHON_DEPS} )
	virtual/pkgconfig"

RESTRICT="!test? ( test )"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	sed -i \
		-e 's/ -g"/"/g' \
		configure.ac || die "sed failed"

	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-valgrind
		$(use_enable debug)
		$(use_enable gnutls tls)
		$(use_enable openssl tls-openssl)
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	emake -j1 check
}

src_install() {
	local DOCS=( ChangeLog )
	use doc && local HTML_DOCS=( doc/relp.html )
	default

	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi
}
