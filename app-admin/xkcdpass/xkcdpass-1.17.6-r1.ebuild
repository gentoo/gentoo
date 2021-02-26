# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Password generator inspired by XKCD 936"
HOMEPAGE="https://github.com/redacted/XKCD-password-generator"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD CC-BY-3.0
	l10n_de? ( GPL-3 )
	l10n_it? ( CC-BY-SA-3.0 )
	l10n_no? ( CC-BY-4.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="l10n_de l10n_en l10n_es l10n_fi l10n_fr l10n_it l10n_no l10n_pt"

PATCHES=( "${FILESDIR}"/xkcdpass-manpage-fix.patch )

src_prepare() {
	default

	use l10n_de || rm ${PN}/static/ger-anlx
	use l10n_en || rm ${PN}/static/{eff-short,eff-special,legacy}
	use l10n_es || rm ${PN}/static/spa-mich
	use l10n_fi || rm ${PN}/static/fin-kotus
	use l10n_fr || rm ${PN}/static/fr-*
	use l10n_it || rm ${PN}/static/ita-wiki
	use l10n_no || rm ${PN}/static/nor-nb
	use l10n_pt || rm ${PN}/static/pt-*
}

python_install_all() {
	distutils-r1_python_install_all
	doman ${PN}.1
}
