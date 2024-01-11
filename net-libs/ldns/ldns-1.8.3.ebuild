# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9,10} )
inherit autotools python-single-r1 multilib-minimal

DESCRIPTION="A library with the aim to simplify DNS programming in C"
HOMEPAGE="https://www.nlnetlabs.nl/projects/ldns/"
SRC_URI="https://www.nlnetlabs.nl/downloads/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc examples python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="test" # missing test directory

BDEPEND="
	python? ( dev-lang/swig )
	doc? ( app-text/doxygen )
"
DEPEND="
	python? ( ${PYTHON_DEPS} )
	>=dev-libs/openssl-1.1.1l-r1:0=[${MULTILIB_USEDEP},static-libs?]
	examples? ( net-libs/libpcap )
"
RDEPEND="
	${DEPEND}
	!<net-dns/ldns-utils-1.8.0-r2
"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/ldns-config
)

PATCHES=(
	"${FILESDIR}/ldns-1.8.1-pkgconfig.patch"
	"${FILESDIR}/${P}-docs.patch"
	"${FILESDIR}/${P}-configure-strict.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	# Drop after 1.8.3
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
		$(multilib_native_use_with python pyldns) \
		$(multilib_native_use_with python pyldnsx) \
		--with-ssl="${EPREFIX}"/usr \
		$(multilib_native_with drill) \
		$(multilib_native_use_with examples) \
		--disable-rpath
}

multilib_src_compile() {
	default

	if multilib_is_native_abi && use doc ; then
		emake doxygen
	fi
}

multilib_src_install() {
	default

	if multilib_is_native_abi && use doc ; then
		dodoc -r doc/html
	fi
}

multilib_src_install_all() {
	dodoc Changelog README*

	find "${D}" -name '*.la' -delete || die
	use python && python_optimize

	insinto /usr/share/vim/vimfiles/ftdetect
	doins libdns.vim
}
