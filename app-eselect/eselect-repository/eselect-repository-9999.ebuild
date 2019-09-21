# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/mgorny/eselect-repository.git"
PYTHON_COMPAT=( python{3_5,3_6,3_7} )
inherit git-r3 python-single-r1

DESCRIPTION="Manage repos.conf via eselect"
HOMEPAGE="https://github.com/mgorny/eselect-repository"
SRC_URI=""

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}

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
