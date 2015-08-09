# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=(python{2_7,3_3,3_4})
PYTHON_REQ_USE="readline(+)"

inherit distutils-r1

DESCRIPTION="Replacement for 'emerge --search' with search-index"
HOMEPAGE="https://github.com/fuzzyray/esearch"
SRC_URI="mirror://github/fuzzyray/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="linguas_fr linguas_it"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"

DEPEND="sys-apps/portage"
RDEPEND="${DEPEND}"

# Populate the patches array for any patches for -rX releases
# It is an array of patch file names of the form:
# "${FILESDIR}"/${PV}-fix-EPREFIX-capability.patch
PATCHES=(
	"${FILESDIR}"/${PV}-Fix-setup.py.patch
	"${FILESDIR}"/${PV}-Fix-python-3-compatability.patch
)

python_prepare_all() {
	python_export_best
	echo VERSION="${PVR}" "${PYTHON}" setup.py set_version
	VERSION="${PVR}" "${PYTHON}" setup.py set_version \
		|| die "setup.py set_version failed"
	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	dodoc eupdatedb.cron || die "dodoc failed"

	# Remove unused man pages according to the linguas flags
	if ! use linguas_fr ; then
		rm -rf "${ED}"/usr/share/man/fr \
			|| die "rm failed to remove ${ED}/usr/share/man/fr"
	fi

	if ! use linguas_it ; then
		rm -rf "${ED}"/usr/share/man/it \
			|| die "rm failed to remove ${ED}/usr/share/man/it"
	fi
}
