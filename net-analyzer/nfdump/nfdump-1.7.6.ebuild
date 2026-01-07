# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs systemd

DESCRIPTION="A set of tools to collect and process netflow data"
HOMEPAGE="https://github.com/phaag/nfdump"
SRC_URI="https://github.com/phaag/nfdump/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 x86"
IUSE="debug doc jnat ftconv nfpcapd nfprofile nftrack nsel readpcap sflow zstd"

REQUIRED_USE="?? ( jnat nsel )"

RDEPEND="
	app-arch/bzip2
	app-arch/lz4:=
	virtual/zlib:=
	elibc_musl? ( sys-libs/fts-standalone )
	ftconv? ( net-analyzer/flow-tools )
	nfpcapd? ( net-libs/libpcap )
	nfprofile? ( net-analyzer/rrdtool )
	nftrack? ( net-analyzer/rrdtool )
	readpcap? ( net-libs/libpcap )
	zstd? ( app-arch/zstd:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/yacc
	sys-devel/flex
	doc? (
		app-text/doxygen
		media-gfx/graphviz
	)
"

QA_CONFIG_IMPL_DECL_SKIP=(
	# Not available on Linux, with fallback at src/libnffile/util.h, bug #904952
	htonll
)

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.19-libft.patch
)

DOCS=( AUTHORS ChangeLog README.md )

src_prepare() {
	default

	eautoreconf

	if use doc; then
		doxygen -u doc/Doxyfile.in || die
	fi
}

src_configure() {
	# Needs flex
	unset LEX

	tc-export CC

	# bug #853763
	use elibc_musl && append-libs "-lfts"

	# --without-ftconf is not handled well, bug #322201
	local myeconfargs=(
		$(usex ftconv "--enable-ftconv --with-ftpath=${EPREFIX}/usr")
		$(usex nfpcapd --enable-nfpcapd)
		$(usex nfprofile --enable-nfprofile)
		$(usex nftrack --enable-nftrack)
		$(use_enable debug devel)
		$(use_enable jnat)
		$(use_enable nsel)
		$(use_enable readpcap)
		$(use_enable sflow)
		$(use_with zstd "zstdpath" "${EPREFIX}/usr")
	)
	econf "${myeconfargs[@]}"
}

src_test(){
	pushd src/test || die
	emake -j1 check-TESTS
	popd || die
}

src_install() {
	default

	find "${ED}" -name '*.la' -type f -delete || die

	newinitd "${FILESDIR}"/nfcapd.initd nfcapd
	newconfd "${FILESDIR}"/nfcapd.confd nfcapd
	systemd_newunit "${FILESDIR}/nfdump.service" nfdump@.service

	if use doc; then
		dodoc -r doc/html
	fi
}
