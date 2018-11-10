# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic toolchain-funcs multilib-minimal

DESCRIPTION="ILM's OpenEXR high dynamic-range image file format libraries"
HOMEPAGE="http://openexr.com/"
SRC_URI="https://github.com/openexr/openexr/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/24" # based on SONAME
KEYWORDS="~amd64 -arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="cpu_flags_x86_avx examples static-libs"

RDEPEND="
	>=media-libs/ilmbase-${PV}:=[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-archive-2016.09.16
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"

DOCS=( AUTHORS ChangeLog NEWS README.md )
MULTILIB_WRAPPED_HEADERS=( /usr/include/OpenEXR/OpenEXRConfig.h )

PATCHES=(
	"${FILESDIR}/${PN}-2.2.0-fix-cpuid-on-abi_x86_32.patch"
	"${FILESDIR}/${PN}-2.2.0-fix-config.h-collision.patch"
	"${FILESDIR}/${PN}-2.2.0-Install-missing-header-files.patch"
	"${FILESDIR}/${P}-fix-build-system.patch"
)

src_prepare() {
	default
	# Fix path for testsuite
	sed -i -e "s:/var/tmp/:${T}:" IlmImfTest/tmpDir.h || die
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-imffuzztest
		--disable-imfhugetest
		--enable-threading
		$(use_enable cpu_flags_x86_avx avx)
		$(use_enable examples imfexamples)
		$(use_enable static-libs static)
	)

	# TODO: check if this still applies on updates!
	# internal tool dwaLookup fails to run when linked with gold linker
	tc-ld-disable-gold

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
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
