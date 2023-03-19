# Copyright 2004-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
# NEED_BOOTSTRAP is for developers to quickly generate a tarball
# for publishing to the tree.
NEED_BOOTSTRAP="no"
inherit eapi8-dosym multibuild multilib python-any-r1 flag-o-matic toolchain-funcs multilib-minimal

DESCRIPTION="Extended crypt library for descrypt, md5crypt, bcrypt, and others"
HOMEPAGE="https://github.com/besser82/libxcrypt"
if [[ ${NEED_BOOTSTRAP} == "yes" ]] ; then
	inherit autotools
	SRC_URI="https://github.com/besser82/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
else
	SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-autotools.tar.xz"
fi

LICENSE="LGPL-2.1+ public-domain BSD BSD-2"
SLOT="0/1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="+compat split-usr static-libs +system test headers-only"
REQUIRED_USE="split-usr? ( system )"
RESTRICT="!test? ( test )"

export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY/cross-} != ${CATEGORY} ]] ; then
		export CTARGET=${CATEGORY/cross-}
	fi
fi

is_cross() {
	local enabled_abis=( $(multilib_get_enabled_abis) )
	[[ "${#enabled_abis[@]}" -le 1 ]] && [[ ${CHOST} != ${CTARGET} ]]
}

DEPEND="
	system? (
		elibc_glibc? (
			${CATEGORY}/glibc[-crypt(+)]
			!${CATEGORY}/glibc[crypt(+)]
		)
		elibc_musl? (
			${CATEGORY}/musl[-crypt(+)]
			!${CATEGORY}/musl[crypt(+)]
		)
	)
"
RDEPEND="${DEPEND}"
BDEPEND="dev-lang/perl
	test? ( $(python_gen_any_dep 'dev-python/passlib[${PYTHON_USEDEP}]') )"

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
	MULTIBUILD_VARIANTS=(
		$(usex compat 'xcrypt_compat' '')
		xcrypt_nocompat
	)

	use test && python-any-r1_pkg_setup
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
	# Avoid possible "illegal instruction" errors with gold
	# bug #821496
	tc-ld-disable-gold

	# Doesn't work with LTO: bug #852917.
	# https://github.com/besser82/libxcrypt/issues/24
	filter-lto

	# ideally we want !tc-ld-is-bfd for best future-proofing, but it needs
	# https://github.com/gentoo/gentoo/pull/28355
	# mold needs this too but right now tc-ld-is-mold is also not available
	if tc-ld-is-lld; then
		append-ldflags -Wl,--undefined-version
	fi

	multibuild_foreach_variant multilib-minimal_src_configure
}

get_xcprefix() {
	if is_cross; then
		echo "${EPREFIX}/usr/${CTARGET}"
	else
		echo "${EPREFIX}"
	fi
}

get_xclibdir() {
	printf -- "%s/%s/%s/%s\n" \
		"$(get_xcprefix)" \
		"$(usex split-usr '' '/usr')" \
		"$(get_libdir)" \
		"$(usex system '' 'xcrypt')"
}

get_xcincludedir() {
	printf -- "%s/usr/include/%s\n" \
		"$(get_xcprefix)" \
		"$(usex system '' 'xcrypt')"
}

get_xcmandir() {
	printf -- "%s/usr/share/man\n" \
		"$(get_xcprefix)"
}

get_xcpkgconfigdir() {
	printf -- "%s/usr/%s/pkgconfig\n" \
		"$(get_xcprefix)" \
		"$(get_libdir)"
}

multilib_src_configure() {
	local -a myconf=(
		--host=${CTARGET}
		--disable-werror
		--libdir=$(get_xclibdir)
		--with-pkgconfigdir=$(get_xcpkgconfigdir)
		--includedir=$(get_xcincludedir)
		--mandir="$(get_xcmandir)"
	)

	tc-export PKG_CONFIG

	if is_cross; then
		if tc-is-clang; then
			export CC="${CTARGET}-clang"
		else
			export CC="${CTARGET}-gcc"
		fi
	fi

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

	if use headers-only; then
		# Nothing is compiled here which would affect the headers for the target.
		# So forcing CC is sane.
		headers_only_flags="CC=$(tc-getBUILD_CC)"
	fi

	ECONF_SOURCE="${S}" econf "${myconf[@]}" "${headers_only_flags}"
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
	multibuild_foreach_variant multilib-minimal_src_install

	use headers-only || \
	(
		shopt -s failglob || die "failglob failed"

		# Make sure our man pages do not collide with glibc or man-pages.
		for manpage in "${D}$(get_xcmandir)"/man3/crypt{,_r}.?*; do
			mv -n "${manpage}" "$(dirname "${manpage}")/xcrypt_$(basename "${manpage}")" \
				|| die "mv failed"
		done
	) || die "failglob error"

	# Remove useless stuff from installation
	find "${ED}"/usr/share/doc/${PF} -type l -delete || die
	find "${ED}" -name '*.la' -delete || die

	# workaround broken upstream cross-* --docdir by installing files in proper locations
	if is_cross; then
		insinto "$(get_xcprefix)"/usr/share
		doins -r "${ED}"/usr/share/doc
		rm -r "${ED}"/usr/share/doc || die
	fi
}

multilib_src_install() {
	if use headers-only; then
		emake DESTDIR="${D}" install-nodist_includeHEADERS
		return
	fi

	emake DESTDIR="${D}" install

	# Don't install the libcrypt.so symlink for the "compat" version
	case "${MULTIBUILD_ID}" in
		xcrypt_compat-*)
			rm "${D}"$(get_xclibdir)/libcrypt$(get_libname) \
				|| die "failed to remove extra compat libraries"
		;;
		xcrypt_nocompat-*)
			if use split-usr; then
				(
					if use static-libs; then
						# .a files are installed to /$(get_libdir) by default
						# Move static libraries to /usr prefix or portage will abort
						shopt -s nullglob || die "failglob failed"
						static_libs=( "${D}"/$(get_xclibdir)/*.a )

						if [[ -n ${static_libs[*]} ]]; then
							dodir "/usr/$(get_xclibdir)"
							mv "${static_libs[@]}" "${ED}/usr/$(get_xclibdir)" \
								|| die "Moving static libs failed"
						fi
					fi

					if use system; then
						# Move versionless .so symlinks from /$(get_libdir) to /usr/$(get_libdir)
						# to allow linker to correctly find shared libraries.
						shopt -s failglob || die "failglob failed"

						for lib_file in "${D}"$(get_xclibdir)/*$(get_libname); do
							lib_file_basename="$(basename "${lib_file}")"
							lib_file_target="$(basename "$(readlink -f "${lib_file}")")"

							# We already know we're in split-usr (checked above)
							# See bug #843209 (also worth keeping in mind bug #802222 too)
							local libdir_no_prefix=$(get_xclibdir)
							libdir_no_prefix=${libdir_no_prefix#${EPREFIX}}
							libdir_no_prefix=${libdir_no_prefix%/usr}
							dosym8 -r "/$(get_libdir)/${lib_file_target}" "/usr/${libdir_no_prefix}/${lib_file_basename}"
						done

						rm "${D}"$(get_xclibdir)/*$(get_libname) || die "Removing symlinks in incorrect location failed"
					fi
				)
			fi
		;;
		*) die "Unexpected MULTIBUILD_ID: ${MULTIBUILD_ID}";;
	esac
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
