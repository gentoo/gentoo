# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit autotools flag-o-matic python-any-r1

DESCRIPTION="An easy to use library for the RELP protocol"
HOMEPAGE="
	https://www.rsyslog.com/librelp/
	https://github.com/rsyslog/librelp
"
SRC_URI="https://download.rsyslog.com/${PN}/${P}.tar.gz"

LICENSE="GPL-3+ doc? ( FDL-1.3 )"
# subslot = soname version
SLOT="0/0.5.1"
KEYWORDS="amd64 arm arm64 ~hppa ~ppc64 ~riscv sparc x86"
IUSE="debug doc +ssl +gnutls openssl static-libs test"
REQUIRED_USE="ssl? ( ^^ ( gnutls openssl ) )"
RESTRICT="!test? ( test )"

RDEPEND="
	ssl? (
		gnutls? ( >=net-libs/gnutls-3.3.17.1:= )
		openssl? ( dev-libs/openssl:= )
	)
"
DEPEND="
	${RDEPEND}
	test? ( ${PYTHON_DEPS} )
"
BDEPEND="virtual/pkgconfig"

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
	# https://github.com/rsyslog/librelp/issues/267
	append-cflags -std=gnu17

	local myeconfargs=(
		--disable-valgrind
		--disable-Werror
		$(use_enable debug)
		$(use_enable gnutls tls)
		$(use_enable openssl tls-openssl)
		$(use_enable static-libs static)
	)

	CONFIG_SHELL="${BROOT}"/bin/bash econf "${myeconfargs[@]}"
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
