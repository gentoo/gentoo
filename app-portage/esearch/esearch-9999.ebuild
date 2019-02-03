# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=(python{2_7,3_4,3_5,3_6})
PYTHON_REQ_USE="readline(+)"

inherit distutils-r1 git-r3

DESCRIPTION="Replacement for 'emerge --search' with search-index"
HOMEPAGE="https://github.com/fuzzyray/esearch"
EGIT_REPO_URI="https://github.com/fuzzyray/esearch.git"

LICENSE="GPL-2"
SLOT="0"
IUSE="l10n_fr l10n_it"

KEYWORDS=""

DEPEND="
	|| (
		sys-apps/portage
		sys-apps/portage-mgorny
	)"
RDEPEND="${DEPEND}"

python_prepare_all() {
	python_export_best
	echo VERSION="9999-${EGIT_VERSION}" "${PYTHON}" setup.py set_version
	VERSION="9999-${EGIT_VERSION}" "${PYTHON}" setup.py set_version
	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	dodoc eupdatedb.cron || die "dodoc failed"

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
