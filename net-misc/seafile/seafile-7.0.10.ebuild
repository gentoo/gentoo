# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_{7,8,9})

WANT_AUTOMAKE=1.16

inherit autotools python-single-r1 vala

DESCRIPTION="File syncing and sharing software with file encryption and group sharing"
HOMEPAGE="https://www.seafile.com/ https://github.com/haiwen/seafile/"
SRC_URI="https://github.com/haiwen/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+-with-openssl-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	net-libs/libsearpc[${PYTHON_SINGLE_USEDEP}]
	dev-libs/glib:2
	dev-libs/libevent
	dev-libs/jansson
	$(python_gen_cond_dep '
		dev-python/future[${PYTHON_MULTI_USEDEP}]
	')
	sys-libs/zlib
	net-misc/curl
	!libressl? ( dev-libs/openssl )
	libressl? ( dev-libs/libressl )
	dev-db/sqlite:3"
DEPEND="${RDEPEND}
	$(vala_depend)"

src_prepare() {
	default
	sed -i -e 's/valac /${VALAC} /' lib/Makefile.am || die
	eautoreconf
	vala_src_prepare
}

src_install() {
	default
	# Remove unnecessary .la files, as recommended by ltprune.eclass
	find "${ED}" -name '*.la' -o -name '*.a' -delete || die
	python_fix_shebang "${ED}"/usr/bin
}
