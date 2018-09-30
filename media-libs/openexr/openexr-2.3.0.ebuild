# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multilib-minimal

DESCRIPTION="ILM's OpenEXR high dynamic-range image file format libraries"
HOMEPAGE="http://openexr.com/"
SRC_URI="https://github.com/openexr/openexr/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/24" # based on SONAME
KEYWORDS="~amd64 -arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="cpu_flags_x86_avx examples static-libs"

RDEPEND="
	sys-libs/zlib[${MULTILIB_USEDEP}]
	>=media-libs/ilmbase-${PV}:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	>=sys-devel/autoconf-archive-2016.09.16"

DOCS=( AUTHORS ChangeLog NEWS README.md )

src_prepare() {
	default
	# Fix path for testsuite
	sed -i -e "s:/var/tmp/:${T}:" IlmImfTest/tmpDir.h || die
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--enable-threading \
		$(use_enable cpu_flags_x86_avx avx) \
		$(use_enable static-libs static) \
		$(use_enable examples imfexamples)
}

multilib_src_install_all() {
	einstalldocs

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
	else
		rm -rf "${ED%/}"/usr/share/doc/${PF}/examples || die
	fi

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
