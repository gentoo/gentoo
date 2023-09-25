# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

# Upstream is moving tags repeatedly, then we use commit hash.
# (Please file a bug upstream if this happens!)
#RELEASE_COMMIT="6bd36a957573eda6a53f3d1bc538dbfc001aa9fd"

inherit autotools python-single-r1 vala

DESCRIPTION="File syncing and sharing software with file encryption and group sharing"
HOMEPAGE="https://www.seafile.com/ https://github.com/haiwen/seafile/"
#SRC_URI="https://github.com/haiwen/${PN}/archive/${RELEASE_COMMIT}.tar.gz -> ${P}.tar.gz"
#S="${WORKDIR}/${PN}-${RELEASE_COMMIT}"
SRC_URI="https://github.com/haiwen/seafile/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

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
	dev-libs/jansson:=
	dev-libs/libevent:=
	net-libs/libwebsockets:=[client]
	net-libs/libsearpc[${PYTHON_SINGLE_USEDEP}]
	net-misc/curl
	sys-apps/util-linux
	sys-libs/zlib
	elibc_musl? ( sys-libs/fts-standalone )"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}
	$(vala_depend)"

pkg_setup() {
	python-single-r1_pkg_setup
	vala_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-static
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	# Remove unnecessary .la files
	find "${ED}" -name '*.la' -delete || die
	python_fix_shebang "${ED}"/usr/bin/seaf-cli
}
