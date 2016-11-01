# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )
USE_RUBY="ruby21 ruby22 ruby23"

# No, I am not calling ruby-ng
inherit multilib python-r1 toolchain-funcs eutils multilib-minimal

MY_P="${P//_/-}"
SEPOL_VER="${PV}"

DESCRIPTION="SELinux userland library"
HOMEPAGE="https://github.com/SELinuxProject/selinux/wiki"
SRC_URI="https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/20160223/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~mips x86"

IUSE="python ruby static-libs ruby_targets_ruby21 ruby_targets_ruby22 ruby_targets_ruby23"

RDEPEND=">=sys-libs/libsepol-${SEPOL_VER}[${MULTILIB_USEDEP}]
	>=dev-libs/libpcre-8.33-r1:=[static-libs?,${MULTILIB_USEDEP}]
	python? ( ${PYTHON_DEPS} )
	ruby? (
		ruby_targets_ruby21? ( dev-lang/ruby:2.1 )
		ruby_targets_ruby22? ( dev-lang/ruby:2.2 )
		ruby_targets_ruby23? ( dev-lang/ruby:2.3 )
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	python? ( >=dev-lang/swig-2.0.9 )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/0005-use-ruby-include-with-rubylibver.patch"
	epatch "${FILESDIR}/0007-build-related-fixes-bug-500674-for-2.5.patch"

	epatch_user

	multilib_copy_sources
}

multilib_src_compile() {
	tc-export PKG_CONFIG RANLIB
	local PCRE_CFLAGS=$(${PKG_CONFIG} libpcre --cflags)
	local PCRE_LIBS=$(${PKG_CONFIG} libpcre --libs)
	export PCRE_{CFLAGS,LIBS}

	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		LIBDIR="\$(PREFIX)/$(get_libdir)" \
		SHLIBDIR="\$(DESTDIR)/$(get_libdir)" \
		LDFLAGS="-fPIC ${LDFLAGS} -pthread" \
		all

	if multilib_is_native_abi && use python; then
		building() {
			python_export PYTHON_INCLUDEDIR PYTHON_LIBPATH
			emake \
				CC="$(tc-getCC)" \
				PYINC="-I${PYTHON_INCLUDEDIR}" \
				PYTHONLIBDIR="${PYTHON_LIBPATH}" \
				PYPREFIX="${EPYTHON##*/}" \
				LDFLAGS="-fPIC ${LDFLAGS} -lpthread" \
				LIBDIR="\$(PREFIX)/$(get_libdir)" \
				SHLIBDIR="\$(DESTDIR)/$(get_libdir)" \
				pywrap
		}
		python_foreach_impl building
	fi

	if multilib_is_native_abi && use ruby; then
		building() {
			einfo "Calling rubywrap for ${1}"
			# Clean up .lo file to force rebuild
			rm -f src/selinuxswig_ruby_wrap.lo || die
			emake \
				CC="$(tc-getCC)" \
				RUBY=${1} \
				RUBYINSTALL=$(${1} -e 'print RbConfig::CONFIG["vendorarchdir"]') \
				LDFLAGS="-fPIC ${LDFLAGS} -lpthread" \
				LIBDIR="\$(PREFIX)/$(get_libdir)" \
				SHLIBDIR="\$(DESTDIR)/$(get_libdir)" \
				rubywrap
		}
		for RUBYTARGET in ${USE_RUBY}; do
			use ruby_targets_${RUBYTARGET} || continue

			building ${RUBYTARGET}
		done
	fi
}

multilib_src_install() {
	LIBDIR="\$(PREFIX)/$(get_libdir)" SHLIBDIR="\$(DESTDIR)/$(get_libdir)" \
		emake DESTDIR="${D}" install

	if multilib_is_native_abi && use python; then
		installation() {
			LIBDIR="\$(PREFIX)/$(get_libdir)" emake DESTDIR="${D}" install-pywrap
			python_optimize # bug 531638
		}
		python_foreach_impl installation
	fi

	if multilib_is_native_abi && use ruby; then
		installation() {
			einfo "Calling install-rubywrap for ${1}"
			# Forcing (re)build here as otherwise the resulting SO file is used for all ruby versions
			rm src/selinuxswig_ruby_wrap.lo
			LIBDIR="\$(PREFIX)/$(get_libdir)" emake DESTDIR="${D}" \
				RUBY=${1} \
				RUBYINSTALL="${D}/$(${1} -e 'print RbConfig::CONFIG["vendorarchdir"]')" \
				install-rubywrap
		}
		for RUBYTARGET in ${USE_RUBY}; do
			use ruby_targets_${RUBYTARGET} || continue

			installation ${RUBYTARGET}
		done
	fi

	use static-libs || rm "${D}"/usr/lib*/*.a || die
}

pkg_postinst() {
	# Fix bug 473502
	for POLTYPE in ${POLICY_TYPES};
	do
		mkdir -p /etc/selinux/${POLTYPE}/contexts/files || die
		touch /etc/selinux/${POLTYPE}/contexts/files/file_contexts.local || die
		# Fix bug 516608
		for EXPRFILE in file_contexts file_contexts.homedirs file_contexts.local ; do
			if [[ -f "/etc/selinux/${POLTYPE}/contexts/files/${EXPRFILE}" ]]; then
				sefcontext_compile /etc/selinux/${POLTYPE}/contexts/files/${EXPRFILE} \
				|| die "Failed to recompile contexts"
			fi
		done
	done
}
