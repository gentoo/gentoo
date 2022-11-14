# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit autotools python-single-r1

GH_TS="1668377184" # https://bugs.gentoo.org/881037 - bump this UNIX timestamp if the downloaded file changes checksum

DESCRIPTION="A simple C language RPC framework"
HOMEPAGE="https://github.com/haiwen/libsearpc/ http://seafile.com/"
SRC_URI="https://github.com/haiwen/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh@${GH_TS}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.26.0
	>=dev-libs/jansson-2.2.1:="
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		dev-python/simplejson[${PYTHON_USEDEP}]
	')"

src_prepare() {
	default
	sed -i -e "s/(DESTDIR)//" ${PN}.pc.in || die
	eautoreconf
}

src_install() {
	default
	# Remove unnecessary .la files
	find "${ED}" -name '*.la' -delete || die
}
