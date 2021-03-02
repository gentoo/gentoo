# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{7,8,9} pypy3 )
PYTHON_REQ_USE="xml(+),threads(+)"

EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/gentoolkit.git"
inherit distutils-r1 git-r3

DESCRIPTION="Collection of administration scripts for Gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Portage-Tools"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS=""

DEPEND="
	sys-apps/portage[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	sys-apps/gawk
	sys-apps/gentoo-functions"

distutils_enable_tests setup.py

python_prepare_all() {
	python_setup
	echo VERSION="${PVR}" "${PYTHON}" setup.py set_version
	VERSION="${PVR}" "${PYTHON}" setup.py set_version
	distutils-r1_python_prepare_all

	if use prefix-guest ; then
		# use correct repo name, bug #632223
		sed -i \
			-e "/load_profile_data/s/repo='gentoo'/repo='gentoo_prefix'/" \
			pym/gentoolkit/profile.py || die
	fi
}

pkg_postinst() {
	# Create cache directory for revdep-rebuild
	mkdir -p -m 0755 "${EROOT}"/var/cache
	mkdir -p -m 0700 "${EROOT}"/var/cache/revdep-rebuild

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
		elog "    app-portage/portpeek"
		elog "    app-portage/smart-live-rebuild"
	fi
}
