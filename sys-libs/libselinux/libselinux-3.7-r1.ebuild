# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
PYTHON_COMPAT=( python3_{10..13} )
USE_RUBY="ruby31 ruby32 ruby33"

# No, I am not calling ruby-ng
inherit flag-o-matic python-r1 toolchain-funcs multilib-minimal

MY_PV="${PV//_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="SELinux userland library"
HOMEPAGE="https://github.com/SELinuxProject/selinux/wiki"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SELinuxProject/selinux.git"
	S="${WORKDIR}/${P}/${PN}"
else
	SRC_URI="https://github.com/SELinuxProject/selinux/releases/download/${MY_PV}/${MY_P}.tar.gz"
	KEYWORDS="amd64 ~arm arm64 ~mips ~riscv x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="public-domain"
SLOT="0"
IUSE="python ruby static-libs ruby_targets_ruby31 ruby_targets_ruby32 ruby_targets_ruby33"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="dev-libs/libpcre2:=[static-libs?,${MULTILIB_USEDEP}]
	>=sys-libs/libsepol-${PV}:=[${MULTILIB_USEDEP},static-libs(+)]
	python? ( ${PYTHON_DEPS} )
	ruby? (
		ruby_targets_ruby31? ( dev-lang/ruby:3.1 )
		ruby_targets_ruby32? ( dev-lang/ruby:3.2 )
		ruby_targets_ruby33? ( dev-lang/ruby:3.3 )
	)
	elibc_musl? ( sys-libs/fts-standalone )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	python? (
		>=dev-lang/swig-2.0.9
		dev-python/pip[${PYTHON_USEDEP}]
)
	ruby? ( >=dev-lang/swig-2.0.9 )"

src_prepare() {
	eapply_user

	multilib_copy_sources
}

multilib_src_compile() {
	tc-export AR CC PKG_CONFIG RANLIB

	# bug 905711
	use elibc_musl && append-cppflags -D_LARGEFILE64_SOURCE

	local -x CFLAGS="${CFLAGS} -fno-semantic-interposition"

	emake \
		LIBDIR="\$(PREFIX)/$(get_libdir)" \
		SHLIBDIR="/$(get_libdir)" \
		LDFLAGS="-fPIC ${LDFLAGS} -pthread" \
		USE_PCRE2=y \
		FTS_LDLIBS="$(usex elibc_musl '-lfts' '')" \
		all

	if multilib_is_native_abi && use python; then
		building() {
			emake \
				LDFLAGS="-fPIC ${LDFLAGS} -lpthread" \
				LIBDIR="\$(PREFIX)/$(get_libdir)" \
				SHLIBDIR="/$(get_libdir)" \
				USE_PCRE2=y \
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
				USE_PCRE2=y \
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
		USE_PCRE2=y \
		install

	if multilib_is_native_abi && use python; then
		installation() {
			emake DESTDIR="${D}" \
				LIBDIR="\$(PREFIX)/$(get_libdir)" \
				SHLIBDIR="/$(get_libdir)" \
				USE_PCRE2=y \
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
				USE_PCRE2=y \
				install-rubywrap
		}
		for RUBYTARGET in ${USE_RUBY}; do
			use ruby_targets_${RUBYTARGET} || continue

			installation ${RUBYTARGET}
		done
	fi

	use static-libs || rm "${ED}"/usr/$(get_libdir)/*.a || die
}

pkg_postinst() {
	# Fix bug 473502
	for POLTYPE in ${POLICY_TYPES};
	do
		mkdir -p "${ROOT}/etc/selinux/${POLTYPE}/contexts/files" || die
		touch "${ROOT}/etc/selinux/${POLTYPE}/contexts/files/file_contexts.local" || die
		# Fix bug 516608
		for EXPRFILE in file_contexts file_contexts.homedirs file_contexts.local ; do
			if [[ -f "${ROOT}/etc/selinux/${POLTYPE}/contexts/files/${EXPRFILE}" ]]; then
				sefcontext_compile "${ROOT}/etc/selinux/${POLTYPE}/contexts/files/${EXPRFILE}" \
				|| die "Failed to recompile contexts"
			fi
		done
	done
}
