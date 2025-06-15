# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

DESCRIPTION="The Theora Video Compression Codec"
HOMEPAGE="https://www.theora.org"
SRC_URI="https://downloads.xiph.org/releases/theora/${P/_}.tar.xz"
S="${WORKDIR}"/${P/_}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="doc +encode examples static-libs"

REQUIRED_USE="examples? ( encode )" # bug #285895

RDEPEND="
	>=media-libs/libogg-1.3.0:=[${MULTILIB_USEDEP}]
	encode? ( >=media-libs/libvorbis-1.3.3-r1:=[${MULTILIB_USEDEP}] )
	examples? (
		media-libs/libpng:=
		>=media-libs/libsdl-0.11.0
		media-libs/libvorbis:=
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"

VARTEXFONTS=${T}/fonts

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.0-flags.patch
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	use doc || export ac_cv_prog_HAVE_DOXYGEN=false

	local myconf=(
		# --disable-spec because LaTeX documentation has been prebuilt
		# ditto docs
		--disable-doc
		--disable-spec
		$(use_enable encode)
		$(multilib_native_use_enable examples)
		$(use_enable static-libs static)
	)

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install() {
	emake \
		DESTDIR="${D}" \
		docdir="${EPREFIX}"/usr/share/doc/${PF} \
		install

	if multilib_is_native_abi && use examples ; then
		dobin examples/.libs/png2theora

		local bin
		for bin in dump_{psnr,video} {encoder,player}_example; do
			newbin examples/.libs/${bin} theora_${bin}
		done
	fi
}

multilib_src_install_all() {
	find "${ED}" -name '*.la' -delete || die

	einstalldocs

	if use examples ; then
		docinto examples
		dodoc examples/*.[ch]
		docompress -x /usr/share/doc/${PF}/examples
		docinto .
	fi
}
