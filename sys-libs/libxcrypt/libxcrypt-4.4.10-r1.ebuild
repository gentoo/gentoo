# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )
inherit autotools multibuild python-any-r1 multilib-minimal

DESCRIPTION="Extended crypt library for descrypt, md5crypt, bcrypt, and others "
SRC_URI="https://github.com/besser82/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://github.com/besser82/libxcrypt"

LICENSE="LGPL-2.1+ public-domain BSD BSD-2"
SLOT="0/1"
KEYWORDS="~amd64 ~x86"
IUSE="+compat split-usr static-libs system test"

DEPEND="system? (
		elibc_glibc? ( sys-libs/glibc[-crypt(+)] )
		!sys-libs/musl
	)"
RDEPEND="${DEPEND}"
BDEPEND="sys-apps/findutils
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/passlib[${PYTHON_USEDEP}]')
	)"

# Gentoo CI complained about not having this
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/libxcrypt-4.4.10-pythonver.patch"
	"${FILESDIR}/libxcrypt-4.4.10-multibuild.patch"
)

pkg_setup() {
	MULTIBUILD_VARIANTS=(
		$(usex compat 'xcrypt_compat' '')
		xcrypt_nocompat
	)

	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	multibuild_foreach_variant multilib-minimal_src_configure
}

get_xclibdir() {
	printf -- "%s\n" "$(usex split-usr '' '/usr')/$(get_libdir)/$(usex system '' 'xcrypt')"
}

multilib_src_configure() {
	local -a myconf=(
		--libdir=$(get_xclibdir)
		--with-pkgconfigdir=/usr/$(get_libdir)/pkgconfig
		--includedir="${EPREFIX}/usr/include/$(usex system '' 'xcrypt')"
	)

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

	(
		shopt -s failglob || die "failglob failed"

		# make sure out man pages don't collide with glibc or man-pages
		for manpage in "${ED}"/usr/share/man/man3/crypt{,_r}.?*; do
			mv -n "${manpage}" "$(dirname "${manpage}")/xcrypt_$(basename "${manpage}")" \
				|| die "mv failed"
		done
	) || die "failglob error"

	# remove useless stuff from installation
	find "${D}"/usr/share/doc/${PF} -type l -delete || die
	find "${D}" -name '*.la' -delete || die
}

multilib_install() {
	local install_target

	case "${MULTIBUILD_ID}" in
		xcrypt_compat-*) install_target="install-libLTLIBRARIES";;
		xcrypt_nocompat-*)
			if is_final_abi; then
				install_target="install"
			else
				install_target="install-libLTLIBRARIES"
			fi
			;;
		*) die "Unexpected MULTIBUILD_ID: ${MULTIBUILD_ID}";;
	esac

	emake DESTDIR="${D}" ${install_target}

	# don't install the libcrypt.so symlink for the "compat" version
	case "${MULTIBUILD_ID}" in
		xcrypt_compat-*)
			rm "${D}"$(get_xclibdir)/libcrypt$(get_libname) \
				"${D}"/usr/include/$(usex system '' 'xcrypt/')xcrypt.h || die
		;;
		xcrypt_nocompat-*)
			if use split-usr; then
				(
					shopt -s failglob || die "failglob failed"

					for so_file in "${D}"$(get_xclibdir)/*$(get_libname)*; do
						so_file=$(basename "${so_file}") || die

						dosym ../../$(usex system '' '../')$(get_libdir)/$(usex system '' 'xcrypt')/${so_file} \
							/usr/$(get_libdir)/$(usex system '' 'xcrypt/')${so_file}
					done
				) || die "symlinking library failure"
			fi
			;;
	esac
}
