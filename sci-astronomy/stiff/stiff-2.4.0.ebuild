# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == "9999" ]] ; then
	inherit subversion
	ESVN_REPO_URI="https://astromatic.net/pubsvn/software/${PN}/trunk"
else
	inherit flag-o-matic
	SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Converts astronomical FITS images to the TIFF format"
HOMEPAGE="http://www.astronomatic.net/software/stiff"

LICENSE="GPL-3"
SLOT="0"
IUSE="doc threads"

RDEPEND="
	media-libs/tiff:0=
	virtual/jpeg:0
	sys-libs/zlib:0="
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# bug #708382
	append-cflags -fcommon
}

src_configure() {
	CONFIG_SHELL="${EPREFIX}/bin/bash" ECONF_SOURCE="${S}" econf \
		$(use_enable threads)
}

src_install() {
	default
	use doc && dodoc doc/stiff.pdf
}
