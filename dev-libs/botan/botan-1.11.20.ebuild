# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit eutils multilib python-r1 toolchain-funcs

MY_PN="Botan"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="A C++ crypto library"
HOMEPAGE="http://botan.randombit.net/"
SRC_URI="http://botan.randombit.net/releases/${MY_P}.tgz"

KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~ppc-macos"
SLOT="0"
LICENSE="BSD"
IUSE="bindist doc boost python bzip2 lzma sqlite ssl static-libs zlib"

S="${WORKDIR}/${MY_P}"

REQUIRED_USE="python? ( boost )"

RDEPEND="bzip2? ( >=app-arch/bzip2-1.0.5 )
	zlib? ( >=sys-libs/zlib-1.2.3 )
	boost? ( ${PYTHON_DEPS} >=dev-libs/boost-1.48[python?,${PYTHON_USEDEP}] )
	lzma? ( app-arch/xz-utils )
	sqlite? ( dev-db/sqlite:3 )
	ssl? ( >=dev-libs/openssl-0.9.8g:*[bindist=] )"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )"

pkg_pretend() {
	# Botan 1.11 requires -std=c++11
	if [[ ${MERGE_TYPE} != binary ]]; then
		[[ $(gcc-major-version) -lt 4 ]] || \
		( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 7 ]] ) \
		&& die "Sorry, but gcc 4.7 or higher is required."
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${P}-build-python.patch"
	sed \
		-e "/^install:/s/ docs//" \
		-i src/build-data/makefile/gmake.in || die "sed failed"
	use python && python_copy_sources
}

src_configure() {
	local disable_modules=( proc_walk unix_procs )
	use boost || disable_modules+=( "boost" )
	use bindist && disable_modules+=( "ecdsa" )
	elog "Disabling modules: ${disable_modules[@]}"

	# Enable v9 instructions for sparc64
	if [[ "${PROFILE_ARCH}" = "sparc64" ]]; then
		CHOSTARCH="sparc32-v9"
	else
		CHOSTARCH="${CHOST%%-*}"
	fi

	local myos=
	case ${CHOST} in
		*-darwin*)   myos=darwin ;;
		*)           myos=linux  ;;
	esac

	local pythonvers=()
	if use python; then
		append() {
			pythonvers+=( ${EPYTHON/python/} )
		}
		python_foreach_impl append
	fi

	./configure.py \
		--prefix="${EPREFIX}/usr" \
		--destdir="${D}/${EPREFIX}/usr" \
		--libdir=$(get_libdir) \
		--docdir=share/doc \
		--cc=gcc \
		--os=${myos} \
		--cpu=${CHOSTARCH} \
		--with-endian="$(tc-endian)" \
		--without-sphinx \
		$(use_with bzip2) \
		$(use_with lzma) \
		$(use_with sqlite sqlite3) \
		$(use_with ssl openssl) \
		$(use_with zlib) \
		$(use_with boost) \
		--with-python-version=$(IFS=","; echo "${pythonvers[*]}" ) \
		--disable-modules=$(IFS=","; echo "${disable_modules[*]}" ) \
		|| die "configure.py failed"
}

src_compile() {
	emake CXX="$(tc-getCXX) -pthread" AR="$(tc-getAR) crs" LIB_OPT="-c ${CXXFLAGS}"
	if use doc; then
		einfo "Generation of documentation"
		sphinx-build doc doc_output
	fi
}

src_test() {
	LD_LIBRARY_PATH="${S}" ./botan-test || die "Validation tests failed"
}

src_install() {
	emake install

	if ! use static-libs; then
		rm "${ED}usr/$(get_libdir)/libbotan"*.a || die 'remove of static libs failed'
	fi

	# Add compatibility symlinks.
	[[ -e "${ED}usr/bin/botan-config" ]] && die "Compatibility code no longer needed"
	[[ -e "${ED}usr/$(get_libdir)/pkgconfig/botan.pc" ]] && die "Compatibility code no longer needed"
	dosym botan-config-1.11 /usr/bin/botan-config
	dosym botan-1.11.pc /usr/$(get_libdir)/pkgconfig/botan.pc

	use python && python_foreach_impl python_optimize

	if use doc; then
		pushd doc_output > /dev/null
		insinto /usr/share/doc/${PF}/html
		doins -r [a-z]* _static
		popd > /dev/null
	fi
}
