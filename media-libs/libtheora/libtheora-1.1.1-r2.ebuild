# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="The Theora Video Compression Codec"
HOMEPAGE="https://www.theora.org"
SRC_URI="https://downloads.xiph.org/releases/theora/${P/_}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"
IUSE="doc +encode examples static-libs"

REQUIRED_USE="examples? ( encode )" #285895

RDEPEND="
	>=media-libs/libogg-1.3.0:=[${MULTILIB_USEDEP}]
	encode? ( >=media-libs/libvorbis-1.3.3-r1:=[${MULTILIB_USEDEP}] )
	examples? (
		media-libs/libpng:0=
		>=media-libs/libsdl-0.11.0
		media-libs/libvorbis:=
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

S=${WORKDIR}/${P/_}

VARTEXFONTS=${T}/fonts

DOCS=( AUTHORS CHANGES README )

PATCHES=(
	"${FILESDIR}"/${PN}-1.0_beta2-flags.patch
	"${FILESDIR}"/${P}-underlinking.patch
	"${FILESDIR}"/${P}-libpng16.patch # bug 465450
	"${FILESDIR}"/${P}-fix-UB.patch # bug 620800
)

src_prepare() {
	default

	# bug 467006
	sed -i "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" configure.ac || die

	AT_M4DIR=m4 eautoreconf
}

multilib_src_configure() {
	use x86 && filter-flags -fforce-addr -frename-registers #200549
	use doc || export ac_cv_prog_HAVE_DOXYGEN=false

	local myconf=(
		--disable-spec
		$(use_enable encode)
		$(use_enable static-libs static)
	)

	if [[ "${ABI}" = "${DEFAULT_ABI}" ]] ; then
		myconf+=( $(use_enable examples) )
	else
		# those will be overwritten anyway
		myconf+=( --disable-examples )
	fi

	# --disable-spec because LaTeX documentation has been prebuilt
	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install() {
	emake \
		DESTDIR="${D}" \
		docdir="${EPREFIX}"/usr/share/doc/${PF} \
		install

	if use examples && [[ "${ABI}" = "${DEFAULT_ABI}" ]]; then
		dobin examples/.libs/png2theora
		for bin in dump_{psnr,video} {encoder,player}_example; do
			newbin examples/.libs/${bin} theora_${bin}
		done
	fi
}

multilib_src_install_all() {
	find "${D}" -name '*.la' -delete || die
	einstalldocs

	if use examples && use doc; then
		docinto examples
		dodoc examples/*.[ch]
		docompress -x /usr/share/doc/${PF}/examples
		docinto .
	fi
}
