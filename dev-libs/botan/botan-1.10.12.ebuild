# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit eutils multilib python-r1 toolchain-funcs

MY_PN="Botan"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="A C++ crypto library"
HOMEPAGE="http://botan.randombit.net/"
SRC_URI="http://botan.randombit.net/releases/${MY_P}.tgz"

KEYWORDS="amd64 ~arm hppa ~ia64 ~ppc ppc64 ~sparc x86 ~ppc-macos"
SLOT="0"
LICENSE="BSD"
IUSE="bindist doc python bzip2 gmp ssl static-libs threads zlib"

S="${WORKDIR}/${MY_P}"

RDEPEND="bzip2? ( >=app-arch/bzip2-1.0.5 )
	zlib? ( >=sys-libs/zlib-1.2.3 )
	python? ( ${PYTHON_DEPS} >=dev-libs/boost-1.48[python,${PYTHON_USEDEP}] )
	gmp? ( >=dev-libs/gmp-4.2.2:* )
	ssl? ( >=dev-libs/openssl-0.9.8g:*[bindist=] )"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )"

src_prepare() {
	default

	sed -e "s/-Wl,-soname,\$@ //" -i src/build-data/makefile/python.in || die "sed failed"
	sed \
		-e "/DOCDIR/d" \
		-e "/^install:/s/ docs//" \
		-i src/build-data/makefile/unix_shr.in || die "sed failed"

	# Fix ImportError with Python 3.
	sed -e "s/_botan/.&/" -i src/wrap/python/__init__.py || die "sed failed"

	use python && python_copy_sources
}

src_configure() {
	local disable_modules="proc_walk,unix_procs"
	use threads || disable_modules+=",pthreads"
	use bindist && disable_modules+=",ecdsa"
	elog "Disabling modules: ${disable_modules}"

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

	# foobared buildsystem, --prefix translates into DESTDIR, see also make
	# install in src_install, we need the correct live-system prefix here on
	# Darwin for a shared lib with correct install_name
	./configure.py \
		--prefix="${EPREFIX}/usr" \
		--libdir=$(get_libdir) \
		--docdir=share/doc \
		--cc=gcc \
		--os=${myos} \
		--cpu=${CHOSTARCH} \
		--with-endian="$(tc-endian)" \
		--without-sphinx \
		--with-tr1=system \
		$(use_with bzip2) \
		$(use_with gmp gnump) \
		$(use_with python boost-python) \
		$(use_with ssl openssl) \
		$(use_with zlib) \
		--disable-modules=${disable_modules} \
		|| die "configure.py failed"
}

src_compile() {
	emake CXX="$(tc-getCXX)" AR="$(tc-getAR) crs" LIB_OPT="${CXXFLAGS}" MACH_OPT=""

	if use python; then
		building() {
			rm -fr build/python
			ln -s "${BUILD_DIR}" build/python
			cp Makefile.python build/python
			sed -i \
				-e "s/-lboost_python/-lboost_python-$(echo ${EPYTHON} | sed 's/python//')/" \
				build/python/Makefile.python
			emake -f build/python/Makefile.python \
				CXX="$(tc-getCXX)" \
				CFLAGS="${CXXFLAGS}" \
				LDFLAGS="${LDFLAGS}" \
				PYTHON_ROOT="/usr/$(get_libdir)" \
				PYTHON_INC="-I$(python_get_includedir)"
		}
		python_foreach_impl building
	fi

	if use doc; then
		einfo "Generation of documentation"
		sphinx-build doc doc_output
	fi
}

src_test() {
	chmod -R ugo+rX "${S}"
	emake CXX="$(tc-getCXX)" CHECK_OPT="${CXXFLAGS}" check
	LD_LIBRARY_PATH="${S}" ./check --validate || die "Validation tests failed"
}

src_install() {
	emake DESTDIR="${ED}usr" install

	if ! use static-libs; then
		rm "${ED}usr/$(get_libdir)/libbotan"*.a || die 'remove of static libs failed'
	fi

	# Add compatibility symlinks.
	[[ -e "${ED}usr/bin/botan-config" ]] && die "Compatibility code no longer needed"
	[[ -e "${ED}usr/$(get_libdir)/pkgconfig/botan.pc" ]] && die "Compatibility code no longer needed"
	dosym botan-config-1.10 /usr/bin/botan-config
	dosym botan-1.10.pc /usr/$(get_libdir)/pkgconfig/botan.pc

	if use python; then
		installation() {
			rm -fr build/python
			ln -s "${BUILD_DIR}" build/python
			emake -f Makefile.python \
				PYTHON_SITE_PACKAGE_DIR="${ED}$(python_get_sitedir)" \
				install
		}
		python_foreach_impl installation
	fi

	if use doc; then
		pushd doc_output > /dev/null
		insinto /usr/share/doc/${PF}/html
		doins -r [a-z]* _static
		popd > /dev/null
	fi
}
