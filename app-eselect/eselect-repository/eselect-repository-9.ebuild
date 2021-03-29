# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit python-single-r1

DESCRIPTION="Manage repos.conf via eselect"
HOMEPAGE="https://github.com/mgorny/eselect-repository"
SRC_URI="https://github.com/mgorny/eselect-repository/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x64-macos"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="${PYTHON_DEPS}
	app-admin/eselect
	$(python_gen_cond_dep '
		dev-python/lxml[${PYTHON_MULTI_USEDEP}]
	')
	net-misc/wget"

src_compile() {
	MAKEARGS=(
		PREFIX="${EPREFIX}/usr"
		SYSCONFDIR="${EPREFIX}/etc"
		SHAREDSTATEDIR="${EPREFIX}/var"
		ESELECTDIR="${EPREFIX}/usr/share/eselect/modules"
	)

	emake "${MAKEARGS[@]}"
	python_fix_shebang eselect-repo-helper
}

src_install() {
	emake "${MAKEARGS[@]}" DESTDIR="${D}" install
	einstalldocs
}
