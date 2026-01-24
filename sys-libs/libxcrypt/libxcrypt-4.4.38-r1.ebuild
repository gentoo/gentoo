# Copyright 2004-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
# NEED_BOOTSTRAP is for developers to quickly generate a tarball
# for publishing to the tree.
NEED_BOOTSTRAP="no"
inherit crossdev multibuild multilib python-any-r1 flag-o-matic toolchain-funcs multilib-minimal

DESCRIPTION="Extended crypt library for descrypt, md5crypt, bcrypt, and others"
HOMEPAGE="https://github.com/besser82/libxcrypt"
if [[ ${NEED_BOOTSTRAP} == "yes" ]] ; then
	inherit autotools
	SRC_URI="https://github.com/besser82/libxcrypt/releases/download/v${PV}/${P}.tar.xz"
else
	SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-autotools.tar.xz"
fi

LICENSE="LGPL-2.1+ public-domain BSD BSD-2"
SLOT="0/1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="+compat static-libs +system test headers-only"
RESTRICT="!test? ( test )"

DEPEND="
	system? (
		elibc_glibc? (
			${CATEGORY}/glibc[-crypt(-)]
			!${CATEGORY}/glibc[crypt(-)]
		)
		elibc_musl? (
			${CATEGORY}/musl[-crypt(+)]
			!${CATEGORY}/musl[crypt(+)]
		)
	)
"
RDEPEND="${DEPEND}
	!<sys-apps/man-pages-6.16-r1
"
BDEPEND="
	dev-lang/perl
	test? ( $(python_gen_any_dep 'dev-python/passlib[${PYTHON_USEDEP}]') )
"

python_check_deps() {
	python_has_version "dev-python/passlib[${PYTHON_USEDEP}]"
}

pkg_pretend() {
	if has "distcc" ${FEATURES} ; then
		ewarn "Please verify all distcc nodes are using the same versions of GCC (>= 10) and Binutils!"
		ewarn "Older/mismatched versions of GCC may lead to a misbehaving library: bug #823179."

		if [[ ${BUILD_TYPE} != "binary" ]] && tc-is-gcc && [[ $(gcc-major-version) -lt 10 ]] ; then
			die "libxcrypt is known to fail to build or be broken at runtime with < GCC 10 (bug #823179)!"
		fi
	fi
}

pkg_setup() {
	:
}

src_prepare() {
	default

	# WARNING: Please read on bumping or applying patches!
	#
	# There are two circular dependencies to be aware of:
	# 1)
	#	if we're bootstrapping configure and makefiles:
	#		libxcrypt -> automake -> perl -> libxcrypt
	#
	#   mitigation:
	#		toolchain@ manually runs `make dist` after running autoconf + `./configure`
	#		and the ebuild uses that.
	#		(Don't include the pre-generated Perl artefacts.)
	#
	#	solution for future:
	#		Upstream are working on producing `make dist` tarballs.
	#		https://github.com/besser82/libxcrypt/issues/134#issuecomment-871833573
	#
	# 2)
	#	configure *unconditionally* needs Perl at build time to generate
	#	a list of enabled algorithms based on the set passed to `configure`:
	#		libxcrypt -> perl -> libxcrypt
	#
	#	mitigation:
	#		None at the moment.
	#
	#	solution for future:
	#		Not possible right now. Upstream intend on depending on Perl for further
	#		configuration options.
	#		https://github.com/besser82/libxcrypt/issues/134#issuecomment-871833573
	#
	# Therefore, on changes (inc. bumps):
	#	* You must check whether upstream have started providing tarballs with bootstrapped
	#	  auto{conf,make};
	#
	#	* diff the build system changes!
	#
	if [[ ${NEED_BOOTSTRAP} == "yes" ]] ; then
		# Facilitate our split variant build for compat + non-compat
		eapply "${FILESDIR}"/${PN}-4.4.19-multibuild.patch
		eautoreconf
	fi
}

src_configure() {
	MULTIBUILD_VARIANTS=(
		$(usev compat 'xcrypt_compat')
		xcrypt_nocompat
	)

	MYPREFIX=${EPREFIX}
	MYSYSROOT=${ESYSROOT}

	if target_is_not_host; then
		# Hack to work around missing TARGET_CC support.
		# See bug 949976.
		if tc-is-clang; then
			export CC="${CTARGET}-clang"
		else
			export CC="${CTARGET}-gcc"
		fi

		local CHOST=${CTARGET}

		MYPREFIX=
		MYSYSROOT=${ESYSROOT}/usr/${CTARGET}

		# Ensure we get compatible libdir
		unset DEFAULT_ABI MULTILIB_ABIS
		multilib_env
		ABI=${DEFAULT_ABI}

		strip-unsupported-flags
	fi

	if use headers-only; then
		# Nothing is compiled which would affect the headers, so we set
		# CC and PKG_CONFIG to ensure configure passes without defaulting
		# to the unprefixed host variants e.g. "pkg-config"
		local -x CC="$(tc-getBUILD_CC)"
		local -x PKG_CONFIG="false"
	fi

	# Doesn't work with LTO: bug #852917.
	# https://github.com/besser82/libxcrypt/issues/24
	filter-lto

	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

	if use test; then
		python_setup
	fi

	multibuild_foreach_variant multilib-minimal_src_configure
}

multilib_src_configure() {
	local myconf=(
		--disable-werror
		--prefix="${MYPREFIX}/usr"
		--libdir="${MYPREFIX}/usr/$(get_libdir)$(usev !system /xcrypt)"
		--includedir="${MYPREFIX}/usr/include$(usev !system /xcrypt)"
		--with-pkgconfigdir="${MYPREFIX}/usr/$(get_libdir)/pkgconfig"
		--with-sysroot="${MYSYSROOT}"
	)

	tc-export PKG_CONFIG

	case "${MULTIBUILD_ID}" in
		xcrypt_compat-*)
			myconf+=(
				--disable-static
				--disable-xcrypt-compat-files
				--enable-obsolete-api=yes
			)
			;;
		xcrypt_nocompat-*)
			myconf+=(
				--enable-obsolete-api=no
				$(use_enable static-libs static)
			)
			;;
		*) die "Unexpected MULTIBUILD_ID: ${MULTIBUILD_ID}";;
	esac

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

src_compile() {
	use headers-only && return

	multibuild_foreach_variant multilib-minimal_src_compile
}

multilib_src_test() {
	emake check
}

src_test() {
	multibuild_foreach_variant multilib-minimal_src_test
}

src_install() {
	local DESTDIR=${D}
	if target_is_not_host; then
		DESTDIR=${ED}/usr/${CTARGET}
	fi

	multibuild_foreach_variant multilib-minimal_src_install

	find "${ED}" -name '*.la' -delete || die

	if target_is_not_host; then
		insinto /usr/${CTARGET}/usr/share
		doins -r "${ED}/usr/share/doc"
		rm -r "${ED}/usr/share/doc" || die
		rmdir "${ED}/usr/share" || die
	fi
}

multilib_src_install() {
	if use headers-only; then
		emake DESTDIR="${DESTDIR}" install-nodist_includeHEADERS
	else
		emake DESTDIR="${DESTDIR}" install
	fi
}

pkg_preinst() {
	# Verify we're not in a bad case like bug #843209 with broken symlinks.
	# This can be dropped when, if ever, the split-usr && system && compat case
	# is cleaned up in *_src_install.
	local broken_symlinks=()
	mapfile -d '' broken_symlinks < <(
		find "${ED}" -xtype l -print0
	)

	if [[ ${#broken_symlinks[@]} -gt 0 ]]; then
		eerror "Broken symlinks found before merging!"
		local symlink target resolved
		for symlink in "${broken_symlinks[@]}" ; do
			target="$(readlink "${symlink}")"
			resolved="$(readlink -f "${symlink}")"
			eerror "  '${symlink}' -> '${target}' (${resolved})"
		done
		die "Broken symlinks found! Aborting to avoid damaging system. Please report a bug."
	fi
}
