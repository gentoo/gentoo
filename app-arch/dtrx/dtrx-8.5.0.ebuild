# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 optfeature

DESCRIPTION="Do The Right eXtraction - extracts archives of different formats"
HOMEPAGE="https://github.com/dtrx-py/dtrx/
	https://pypi.org/project/dtrx/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}-py/${PN}.git"
else
	inherit pypi
	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.md )

src_prepare() {
	sed -i '/ *platform==/s|.*||' setup.cfg || die  # bug #894148

	distutils-r1_src_prepare
}

pkg_postinst() {
	local supported_format
	local -a supported_formats=(
		arj
		bzip2
		cpio
		gzip
		lrzip
		lzip
		p7zip
		rpm
		unrar
		unzip
		xz-utils
		zip
		zstd
	)

	for supported_format in ${supported_formats[@]}; do
		optfeature                                                         \
			"extraction of supported archives using ${supported_format}"   \
			app-arch/${supported_format}
	done
}
