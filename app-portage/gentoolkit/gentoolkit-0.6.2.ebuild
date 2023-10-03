# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} pypy3 )
PYTHON_REQ_USE="xml(+),threads(+)"

inherit distutils-r1 tmpfiles

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/gentoolkit.git"
	inherit git-r3
else
	SRC_URI="https://gitweb.gentoo.org/proj/gentoolkit.git/snapshot/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

DESCRIPTION="Collection of administration scripts for Gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Portage-Tools"

LICENSE="GPL-2"
SLOT="0"

# Need newer Portage for eclean-pkg API, bug #900224
DEPEND="
	>=sys-apps/portage-3.0.52[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
	app-alternatives/awk
	sys-apps/gentoo-functions
"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

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
	tmpfiles_process revdep-rebuild.conf

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
