# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit autotools python-single-r1 vcs-snapshot

DESCRIPTION="A simple C language RPC framework"
HOMEPAGE="https://github.com/haiwen/libsearpc/ http://seafile.com/"
#TODO: Use commit hash tarball on next version bump.
SRC_URI="https://github.com/haiwen/${PN}/archive/v3.1-latest.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.26.0
	>=dev-libs/jansson-2.2.1"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		dev-python/simplejson[${PYTHON_MULTI_USEDEP}]
	')"

src_prepare() {
	default
	sed -i -e "s/(DESTDIR)//" ${PN}.pc.in || die
	eautoreconf
}

src_install() {
	default
	# Remove unnecessary .la files, as recommended by ltprune.eclass
	find "${ED}" -name '*.la' -delete || die
	python_fix_shebang "${ED}"usr/bin
}
