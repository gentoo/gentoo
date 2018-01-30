# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multilib-minimal

DESCRIPTION="ILM's OpenEXR high dynamic-range image file format libraries"
HOMEPAGE="http://openexr.com/"
SRC_URI="http://download.savannah.gnu.org/releases/openexr/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/22" # based on SONAME
KEYWORDS="amd64 -arm ~hppa ~ia64 ~ppc ~ppc64 sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="cpu_flags_x86_avx examples static-libs"

RDEPEND="
	sys-libs/zlib[${MULTILIB_USEDEP}]
	>=media-libs/ilmbase-${PV}:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	>=sys-devel/autoconf-archive-2016.09.16"

PATCHES=(
	"${FILESDIR}/${P}-fix-cpuid-on-abi_x86_32.patch"
	"${FILESDIR}/${P}-use-ull-for-64-bit-literals.patch"
	"${FILESDIR}/${P}-fix-build-system.patch"
	"${FILESDIR}/${P}-fix-config.h-collision.patch"
	"${FILESDIR}/${P}-Fix-typo-in-C-bindings.patch"
	"${FILESDIR}/${P}-Install-missing-header-files.patch"
	"${FILESDIR}/${P}-CVE-2017-9110-to-9116-security-fixes.patch"
)

src_prepare() {
	default
	# Fix path for testsuite
	sed -i -e "s:/var/tmp/:${T}:" IlmImfTest/tmpDir.h || die

	# delete stray config files causing havoc
	rm -f config*/OpenEXRConfig.h* || die

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
