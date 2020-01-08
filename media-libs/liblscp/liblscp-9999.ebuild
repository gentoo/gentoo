# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools subversion

DESCRIPTION="C++ library for the Linux Sampler control protocol"
HOMEPAGE="https://www.linuxsampler.org"
ESVN_REPO_URI="https://svn.linuxsampler.org/svn/liblscp/trunk"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="doc"

DEPEND="doc? ( app-doc/doxygen )"

DOCS=( AUTHORS ChangeLog TODO NEWS README )

src_prepare() {
	default

	emake -f Makefile.git
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	use doc && local HTML_DOCS=( doc/html/. )
	default
	find "${D}" -name '*.la' -delete || die
}
