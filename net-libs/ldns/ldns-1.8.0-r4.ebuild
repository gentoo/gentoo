# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9,10} )
inherit python-single-r1 autotools multilib-minimal

DESCRIPTION="A library with the aim to simplify DNS programming in C"
HOMEPAGE="https://www.nlnetlabs.nl/projects/ldns/"
SRC_URI="https://www.nlnetlabs.nl/downloads/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/3"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="+dane doc +ecdsa ed25519 ed448 examples gost python static-libs vim-syntax"

# configure will die if ecdsa is enabled and ssl is not
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

COMMON_DEPEND="
	python? ( ${PYTHON_DEPS} )
	>=dev-libs/openssl-1.0.1e:0=[${MULTILIB_USEDEP}]
	examples? ( net-libs/libpcap )
"
DEPEND="${COMMON_DEPEND}
	python? ( dev-lang/swig )
	doc? ( app-text/doxygen )
"
RDEPEND="${COMMON_DEPEND}
	!<net-dns/ldns-utils-1.8.0-r2
"

RESTRICT="test" # 1.6.9 has no test directory

MULTILIB_CHOST_TOOLS=(
	/usr/bin/ldns-config
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

multilib_src_configure() {
	# >=openssl-1.1.0 required for dane-ta
	if has_version "<dev-libs/openssl-1.1.0"; then
		local dane_ta_usage="--disable-dane-ta-usage"
	else
		local dane_ta_usage=""
	fi

	ECONF_SOURCE=${S} \
	econf \
		$(use_enable static-libs static) \
		$(use_enable gost) \
		$(use_enable ecdsa) \
		$(use_enable ed25519) \
		$(use_enable ed448) \
		$(use_enable dane) \
		$(multilib_native_use_with python pyldns) \
		$(multilib_native_use_with python pyldnsx) \
		--with-ssl="${EPREFIX}"/usr \
		--enable-sha2 \
		$(multilib_native_with drill) \
		$(multilib_native_use_with examples) \
		${dane_ta_usage} \
		--disable-rpath
}

src_prepare() {
	default
	# remove non-existing dependency for target packaging/libldns.pc
	sed -i 's,$(srcdir)/packaging/libldns.pc.in,,' "${S}"/Makefile.in || die 'could not patch Makefile.in'

	# remove $(srcdir) from path for multilib build
	sed -i 's,$(srcdir)/packaging/libldns.pc,packaging/libldns.pc,' "${S}"/Makefile.in || die 'could not patch Makefile.in'

	# remove Libs.private, see bug #695672
	sed -i '/^Libs.private:/d' "${S}"/packaging/libldns.pc.in || die 'could not patch libldns.pc.in'

	# backport https://github.com/NLnetLabs/ldns/commit/bc9d017f6fd8b6b5d2ff6e4489a2931d0aab8184
	sed -i 's/AC_SUBST(VERSION_INFO.*/AC_SUBST(VERSION_INFO, [5:0:2])/' "${S}"/configure.ac || die 'could not patch configure.ac'

	eautoreconf
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

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/ftdetect
		doins libdns.vim
	fi
}
