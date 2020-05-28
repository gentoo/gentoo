# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python3_{6..9} )
USE_RUBY="ruby24 ruby25 ruby26"

# No, I am not calling ruby-ng
inherit multilib python-r1 toolchain-funcs multilib-minimal

MY_P="${P//_/-}"
SEPOL_VER="${PV}"
MY_RELEASEDATE="20191204"

DESCRIPTION="SELinux userland library"
HOMEPAGE="https://github.com/SELinuxProject/selinux/wiki"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SELinuxProject/selinux.git"
	S="${WORKDIR}/${MY_P}/${PN}"
else
	SRC_URI="https://github.com/SELinuxProject/selinux/releases/download/${MY_RELEASEDATE}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="public-domain"
SLOT="0"
IUSE="pcre2 python ruby static-libs ruby_targets_ruby24 ruby_targets_ruby25 ruby_targets_ruby26"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=sys-libs/libsepol-${SEPOL_VER}:=[${MULTILIB_USEDEP}]
	!pcre2? ( >=dev-libs/libpcre-8.33-r1:=[static-libs?,${MULTILIB_USEDEP}] )
	pcre2? ( dev-libs/libpcre2:=[static-libs?,${MULTILIB_USEDEP}] )
	python? ( ${PYTHON_DEPS} )
	ruby? (
		ruby_targets_ruby24? ( dev-lang/ruby:2.4 )
		ruby_targets_ruby25? ( dev-lang/ruby:2.5 )
		ruby_targets_ruby26? ( dev-lang/ruby:2.6 )
	)
	elibc_musl? ( sys-libs/fts-standalone )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	python? ( >=dev-lang/swig-2.0.9 )
	ruby? ( >=dev-lang/swig-2.0.9 )"

src_prepare() {
	eapply_user

	multilib_copy_sources
}

multilib_src_compile() {
	tc-export AR CC PKG_CONFIG RANLIB

	emake \
		LIBDIR="\$(PREFIX)/$(get_libdir)" \
		SHLIBDIR="/$(get_libdir)" \
		LDFLAGS="-fPIC ${LDFLAGS} -pthread" \
		USE_PCRE2="$(usex pcre2 y n)" \
		FTS_LDLIBS="$(usex elibc_musl '-lfts' '')" \
		all

	if multilib_is_native_abi && use python; then
		building() {
			emake \
				LDFLAGS="-fPIC ${LDFLAGS} -lpthread" \
				LIBDIR="\$(PREFIX)/$(get_libdir)" \
				SHLIBDIR="/$(get_libdir)" \
				USE_PCRE2="$(usex pcre2 y n)" \
				FTS_LDLIBS="$(usex elibc_musl '-lfts' '')" \
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
				RUBY=${1} \
				LDFLAGS="-fPIC ${LDFLAGS} -lpthread" \
				LIBDIR="\$(PREFIX)/$(get_libdir)" \
				SHLIBDIR="/$(get_libdir)" \
				USE_PCRE2="$(usex pcre2 y n)" \
				FTS_LDLIBS="$(usex elibc_musl '-lfts' '')" \
				rubywrap
		}
		for RUBYTARGET in ${USE_RUBY}; do
			use ruby_targets_${RUBYTARGET} || continue

			building ${RUBYTARGET}
		done
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" \
		LIBDIR="\$(PREFIX)/$(get_libdir)" \
		SHLIBDIR="/$(get_libdir)" \
		USE_PCRE2="$(usex pcre2 y n)" \
		install

	if multilib_is_native_abi && use python; then
		installation() {
			emake DESTDIR="${D}" \
				LIBDIR="\$(PREFIX)/$(get_libdir)" \
				SHLIBDIR="/$(get_libdir)" \
				USE_PCRE2="$(usex pcre2 y n)" \
				install-pywrap
			python_optimize # bug 531638
		}
		python_foreach_impl installation
	fi

	if multilib_is_native_abi && use ruby; then
		installation() {
			einfo "Calling install-rubywrap for ${1}"
			# Forcing (re)build here as otherwise the resulting SO file is used for all ruby versions
			rm src/selinuxswig_ruby_wrap.lo
			emake DESTDIR="${D}" \
				LIBDIR="\$(PREFIX)/$(get_libdir)" \
				SHLIBDIR="/$(get_libdir)" \
				RUBY=${1} \
				USE_PCRE2="$(usex pcre2 y n)" \
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
