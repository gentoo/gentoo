# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="readline(+)"
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Replacement for 'emerge --search' with search-index"
HOMEPAGE="https://github.com/fuzzyray/esearch"
SRC_URI="https://github.com/downloads/fuzzyray/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="l10n_fr l10n_it"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris"

DEPEND="sys-apps/portage"
RDEPEND="${DEPEND}"

# Populate the patches array for any patches for -rX releases
# It is an array of patch file names of the form:
# "${FILESDIR}"/${PV}-fix-EPREFIX-capability.patch
PATCHES=(
	"${FILESDIR}"/${PV}-Fix-setup.py.patch
	"${FILESDIR}"/${PV}-Fix-python-3-compatability.patch
	"${FILESDIR}"/${PV}-updatedb-quoting.patch
)

python_configure_all() {
	echo VERSION="${PVR}" "${EPYTHON}" setup.py set_version
	VERSION="${PVR}" "${EPYTHON}" setup.py set_version \
		|| die "setup.py set_version failed"
}

python_install_all() {
	distutils-r1_python_install_all
	dodoc eupdatedb.cron

	# Remove unused man pages according to the l10n flags
	if ! use l10n_fr ; then
		rm -rf "${ED}"/usr/share/man/fr \
			|| die "rm failed to remove ${ED}/usr/share/man/fr"
	fi

	if ! use l10n_it ; then
		rm -rf "${ED}"/usr/share/man/it \
			|| die "rm failed to remove ${ED}/usr/share/man/it"
	fi
}
