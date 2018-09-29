# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C++ library for the Linux Sampler control protocol"
HOMEPAGE="https://www.linuxsampler.org"
SRC_URI="https://download.linuxsampler.org/packages/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

DEPEND="doc? ( app-doc/doxygen )"

DOCS=( AUTHORS ChangeLog TODO NEWS README )

src_install() {
	use doc && local HTML_DOCS=( doc/html/. )
	default
}
