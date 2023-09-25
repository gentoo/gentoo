# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Synthesis ToolKit in C++"
HOMEPAGE="https://ccrma.stanford.edu/software/stk/"
SRC_URI="https://ccrma.stanford.edu/software/stk/release/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="alsa debug doc jack oss static-libs"
REQUIRED_USE="|| ( alsa jack oss )"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )"
DEPEND="${RDEPEND}
	dev-lang/perl"

PATCHES=(
	"${FILESDIR}/${PN}-4.5.1"
)

HTML_DOCS=(
	doc/html/.
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	use kernel_linux && append-flags -D__OS_LINUX__

	#breaks with --disable-foo...uses as --enable-foo
	local myconf
	if use debug; then
		myconf="${myconf} --enable-debug"
	fi
	if use oss; then
		myconf="${myconf} --with-oss"
	fi
	if use alsa; then
		myconf="${myconf} --with-alsa"
	fi
	if use jack; then
		myconf="${myconf} --with-jack"
	fi

	econf ${myconf} \
		--enable-shared \
		$(use_enable static-libs static) \
		RAWWAVE_PATH=/usr/share/stk/rawwaves/
}

src_install() {
	dodoc README.md

	# install the lib
	dolib.so src/libstk*
	use static-libs && dolib.a src/libstk*

	# install headers
	insinto /usr/include/stk
	doins include/*.h

	# install rawwaves
	insinto /usr/share/stk/rawwaves
	doins rawwaves/*.raw

	# install docs
	if use doc; then
		einstalldocs
	fi
}
