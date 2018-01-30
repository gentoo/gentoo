# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5,3_6} )
inherit python-single-r1

DESCRIPTION="Manage repos.conf via eselect"
HOMEPAGE="https://github.com/mgorny/eselect-repository"
SRC_URI="https://github.com/mgorny/eselect-repository/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	app-admin/eselect
	dev-python/lxml[${PYTHON_USEDEP}]
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
	keepdir /var/db/repos
	einstalldocs
}
