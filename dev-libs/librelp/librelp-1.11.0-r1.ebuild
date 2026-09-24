# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit autotools python-any-r1

DESCRIPTION="Easy to use library for the RELP protocol"
HOMEPAGE="
	https://www.rsyslog.com/librelp/
	https://github.com/rsyslog/librelp
"
SRC_URI="https://download.rsyslog.com/${PN}/${P}.tar.gz"

LICENSE="GPL-3+ FDL-1.3"
SLOT="0/0.5.1" # subslot = soname version
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~riscv ~sparc ~x86"
IUSE="debug doc +ssl +gnutls static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	ssl? (
		gnutls? ( >=net-libs/gnutls-3.3.17.1:= )
		!gnutls? ( dev-libs/openssl:= )
	)
"
DEPEND="
	${RDEPEND}
	test? ( ${PYTHON_DEPS} )
"
BDEPEND="virtual/pkgconfig"

DOCS=( README ChangeLog )
HTML_DOCS=( doc/relp.html )

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default

	sed -i 's/ -g"/"/g' configure.ac || die
	eautoreconf
}

src_configure() {
	local OPENSSL=no
	local GNUTLS=no

	use ssl && {
		if use gnutls; then
			GNUTLS=yes
		else
			OPENSSL=yes
		fi
	}

	local myeconfargs=(
		--disable-Werror
		--disable-valgrind
		--enable-tls=${GNUTLS}
		--enable-tls-openssl=${OPENSSL}
		$(use_enable debug)
		$(use_enable static-libs static)
	)

	# to fix unexpected operator
	CONFIG_SHELL="${BROOT}"/bin/bash econf "${myeconfargs[@]}"
}

src_install() {
	default

	if ! use static-libs; then
		find "${D}" -type f -name '*.la' -delete || die
	fi
}
