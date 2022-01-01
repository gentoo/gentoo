# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit meson python-any-r1

DESCRIPTION="Tools for managing the osinfo database"
HOMEPAGE="https://libosinfo.org/"
SRC_URI="https://releases.pagure.org/libosinfo/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

# Blocker on old libosinfo as osinfo-db-validate was part of it before
RDEPEND="
	>=dev-libs/glib-2.44:2
	dev-libs/json-glib
	>=app-arch/libarchive-3.0.0:=
	net-libs/libsoup:2.4
	>=dev-libs/libxml2-2.6.0
	!<sys-libs/libosinfo-1.0.0
"
# perl dep is for pod2man (manpages)
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	>=sys-devel/gettext-0.19.8
	dev-lang/perl
	test? (
		$(python_gen_any_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/requests[${PYTHON_USEDEP}]
		')
	)
"

python_check_deps() {
	use test && \
		has_version "dev-python/pytest[${PYTHON_USEDEP}]" && \
		has_version "dev-python/requests[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}
