# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit eutils multilib-minimal python-single-r1

DESCRIPTION="a library with the aim to simplify DNS programming in C"
HOMEPAGE="http://www.nlnetlabs.nl/projects/ldns/"
SRC_URI="http://www.nlnetlabs.nl/downloads/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~riscv s390 ~sh sparc x86 ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="+dane doc +ecdsa gost libressl python static-libs vim-syntax"

# configure will die if ecdsa is enabled and ssl is not
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	python? ( ${PYTHON_DEPS} )
	ecdsa? (
		!libressl? ( >=dev-libs/openssl-1.0.1e:0=[-bindist,${MULTILIB_USEDEP}] )
	)
	!libressl? ( >=dev-libs/openssl-1.0.1e:0=[${MULTILIB_USEDEP}] )
	libressl? ( dev-libs/libressl[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	python? ( dev-lang/swig )
	doc? ( app-doc/doxygen )
"

RESTRICT="test" # 1.6.9 has no test directory

MULTILIB_CHOST_TOOLS=(
	/usr/bin/ldns-config
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		$(use_enable static-libs static) \
		$(use_enable gost) \
		$(use_enable ecdsa) \
		$(use_enable dane) \
		$(multilib_native_use_with python pyldns) \
		$(multilib_native_use_with python pyldnsx) \
		--with-ssl="${EPREFIX}"/usr \
		--enable-sha2 \
		--without-drill \
		--without-examples \
		--disable-dane-ta-usage \
		--disable-rpath

		# >=openssl-1.1.0 required for dane-ta
}

src_prepare() {
	epatch "${FILESDIR}/${P}-CVE-2017-1000231.patch"
	epatch "${FILESDIR}/${P}-CVE-2017-1000232.patch"
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
		dohtml -r doc/html/.
	fi
}

multilib_src_install_all() {
	dodoc Changelog README*

	prune_libtool_files --modules
	use python && python_optimize

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/ftdetect
		doins libdns.vim
	fi

	einfo
	elog "Install net-dns/ldns-utils if you want drill and examples"
	einfo
}
