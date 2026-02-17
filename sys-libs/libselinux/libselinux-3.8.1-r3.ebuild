# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{11..14} )
USE_RUBY="ruby32 ruby33"

# No, I am not calling ruby-ng
inherit distutils-r1 toolchain-funcs multilib-minimal

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
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~riscv ~x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="public-domain"
SLOT="0"
IUSE="python ruby static-libs ruby_targets_ruby32 ruby_targets_ruby33"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="dev-libs/libpcre2:=[static-libs?,${MULTILIB_USEDEP}]
	>=sys-libs/libsepol-${PV}:=[${MULTILIB_USEDEP},static-libs(+)]
	python? ( ${PYTHON_DEPS} )
	ruby? (
		ruby_targets_ruby32? ( dev-lang/ruby:3.2 )
		ruby_targets_ruby33? ( dev-lang/ruby:3.3 )
	)
	elibc_musl? ( sys-libs/fts-standalone )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	python? (
		>=dev-lang/swig-2.0.9
		dev-python/pip[${PYTHON_USEDEP}]
		${PYTHON_DEPS}
		${DISTUTILS_DEPS}
	)
	ruby? ( >=dev-lang/swig-2.0.9 )"

src_prepare() {
	eapply_user

	if use python; then
		distutils-r1_src_prepare
	fi

	multilib_copy_sources
}

multilib_src_configure() {
	default
	if multilib_is_native_abi; then
		if use python; then
			distutils-r1_src_configure
		fi
	fi
}

multilib_src_compile() {
	tc-export AR CC PKG_CONFIG RANLIB

	local -x CFLAGS="${CFLAGS} -fno-semantic-interposition"

	emake \
		LIBDIR="\$(PREFIX)/$(get_libdir)" \
		SHLIBDIR="/$(get_libdir)" \
		LDFLAGS="-fPIC ${LDFLAGS} -pthread" \
		USE_PCRE2=y \
		USE_LFS=y \
		FTS_LDLIBS="$(usex elibc_musl '-lfts' '')" \
		all

	if multilib_is_native_abi; then
		if use python; then
			pushd src >/dev/null || die
			distutils-r1_src_compile
			popd >/dev/null || die
		fi
		if use ruby; then
			building() {
				einfo "Calling rubywrap for ${1}"
				# Clean up .lo file to force rebuild
				rm -f src/selinuxswig_ruby_wrap.lo || die
				emake \
					RUBY=${1} \
					LDFLAGS="-fPIC ${LDFLAGS} -lpthread" \
					LIBDIR="\$(PREFIX)/$(get_libdir)" \
					SHLIBDIR="/$(get_libdir)" \
					USE_LFS=y \
					USE_PCRE2=y \
					FTS_LDLIBS="$(usex elibc_musl '-lfts' '')" \
					rubywrap
			}
			for RUBYTARGET in ${USE_RUBY}; do
				use ruby_targets_${RUBYTARGET} || continue

				building ${RUBYTARGET}
			done
		fi
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" \
		LIBDIR="\$(PREFIX)/$(get_libdir)" \
		SHLIBDIR="/$(get_libdir)" \
		USE_LFS=y \
		USE_PCRE2=y \
		install

	if multilib_is_native_abi; then
		if use python; then
			pushd src >/dev/null || die
			mv selinux.py __init__.py || die
			distutils-r1_src_install
			popd >/dev/null || die
		fi
		if use ruby; then
			installation() {
				einfo "Calling install-rubywrap for ${1}"
				# Forcing (re)build here as otherwise the resulting SO file is used for all ruby versions
				rm src/selinuxswig_ruby_wrap.lo
				emake DESTDIR="${D}" \
					LIBDIR="\$(PREFIX)/$(get_libdir)" \
					SHLIBDIR="/$(get_libdir)" \
					RUBY=${1} \
					USE_LFS=y \
					USE_PCRE2=y \
					install-rubywrap
			}
			for RUBYTARGET in ${USE_RUBY}; do
				use ruby_targets_${RUBYTARGET} || continue

				installation ${RUBYTARGET}
			done
		fi
	fi

	use static-libs || rm "${ED}"/usr/$(get_libdir)/*.a || die
}

python_install() {
	# this installs the C extensions only
	distutils-r1_python_install

	# now explicitly install the python package
	python_moduleinto selinux
	python_domodule __init__.py

	# install the C extension symlink
	local pycext="$(python -c 'import importlib.machinery;print(importlib.machinery.EXTENSION_SUFFIXES[0])' || die)"
	dosym -r "$(python_get_sitedir)/selinux/_selinux${pycext}" "$(python_get_sitedir)/_selinux${pycext}"
}

multilib_src_test() {
	default
	if multilib_is_native_abi; then
		if use python; then
			distutils-r1_src_test
		fi
	fi
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
