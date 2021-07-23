# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_{8,9})

RELEASE_COMMIT="303080b54859d0fc55ce693902c95f9620876c1b"

inherit autotools python-single-r1 vala

DESCRIPTION="File syncing and sharing software with file encryption and group sharing"
HOMEPAGE="https://www.seafile.com/ https://github.com/haiwen/seafile/"
SRC_URI="https://github.com/haiwen/${PN}/archive/${RELEASE_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+-with-openssl-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/future[${PYTHON_USEDEP}]
	')
	dev-libs/openssl:=
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/jansson
	dev-libs/libevent:=
	net-libs/libsearpc[${PYTHON_SINGLE_USEDEP}]
	net-misc/curl
	sys-libs/zlib"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}
	$(vala_depend)"

S="${WORKDIR}/${PN}-${RELEASE_COMMIT}"

src_prepare() {
	default
	eautoreconf
	vala_src_prepare
}

src_configure() {
	local myeconfargs=(
		--disable-static
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	# Remove unnecessary .la files, as recommended by ltprune.eclass
	find "${ED}" -name '*.la' -delete || die
	python_fix_shebang "${ED}"/usr/bin/seaf-cli
}
