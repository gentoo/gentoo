# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=(python{2_7,3_4,3_5,3_6} pypy)
PYTHON_REQ_USE="xml(+),threads(+)"

inherit distutils-r1 git-r3

EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/gentoolkit.git"

DESCRIPTION="Collection of administration scripts for Gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Portage-Tools"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS=""

DEPEND="
	|| (
		sys-apps/portage[${PYTHON_USEDEP}]
		sys-apps/portage-mgorny[${PYTHON_USEDEP}]
	)"
RDEPEND="${DEPEND}
	!app-portage/gentoolkit-dev
	sys-apps/gawk
	sys-apps/gentoo-functions"

python_prepare_all() {
	python_setup
	echo VERSION="9999-${EGIT_VERSION}" "${PYTHON}" setup.py set_version
	VERSION="9999-${EGIT_VERSION}" "${PYTHON}" setup.py set_version
	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	# remove on Gentoo Prefix platforms where it's broken anyway
	if use prefix; then
		elog "The revdep-rebuild command is removed, the preserve-libs"
		elog "feature of portage will handle issues."
		rm "${ED}"/usr/bin/revdep-rebuild*
		rm "${ED}"/usr/share/man/man1/revdep-rebuild.1
		rm -rf "${ED}"/etc/revdep-rebuild
		rm -rf "${ED}"/var
	fi
}

pkg_postinst() {
	# Create cache directory for revdep-rebuild
	mkdir -p -m 0755 "${EROOT%/}"/var/cache
	mkdir -p -m 0700 "${EROOT%/}"/var/cache/revdep-rebuild

	# Only show the elog information on a new install
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog
		elog "For further information on gentoolkit, please read the gentoolkit"
		elog "guide: https://wiki.gentoo.org/wiki/Gentoolkit"
		elog
		elog "Another alternative to equery is app-portage/portage-utils"
		elog
		elog "Additional tools that may be of interest:"
		elog
		elog "    app-admin/eclean-kernel"
		elog "    app-portage/diffmask"
		elog "    app-portage/flaggie"
		elog "    app-portage/install-mask"
		elog "    app-portage/portpeek"
		elog "    app-portage/smart-live-rebuild"
	fi
}
