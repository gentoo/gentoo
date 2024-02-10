# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit multilib meson-multilib python-any-r1 readme.gentoo-r1

DESCRIPTION="A library for configuring and customizing font access"
HOMEPAGE="https://fontconfig.org/"
SRC_URI="https://fontconfig.org/release/${P}.tar.xz"

LICENSE="MIT"
SLOT="1.0"
if ! [[ $(ver_cut 3) -ge 90 ]] ; then
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi
IUSE="doc nls test"
RESTRICT="!test? ( test )"

# - Check minimum freetype & other deps on bumps. See
#   https://gitlab.freedesktop.org/fontconfig/fontconfig/-/blob/main/configure.ac#L314.
#   Note that FT versioning is confusing, need to map it using
#   https://git.savannah.gnu.org/cgit/freetype/freetype2.git/tree/docs/VERSIONS.TXT
#   But sometimes it's actually greater than that, e.g. see Fedora's spec file
#   https://src.fedoraproject.org/rpms/fontconfig/blob/rawhide/f/fontconfig.spec#_1
#
# - Purposefully dropped the xml USE flag and libxml2 support. Expat is the
#   default and used by every distro. See bug #283191.
#
# - There's a test-only dep on json-c.
#   It might become an optional(?) runtime dep in future though. Who knows.
#   Keep an eye on it.
RDEPEND="
	>=dev-libs/expat-2.1.0-r3[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.9.1[${MULTILIB_USEDEP}]
	virtual/libintl[${MULTILIB_USEDEP}]
	!elibc_Darwin? ( !elibc_SunOS? ( sys-apps/util-linux[${MULTILIB_USEDEP}] ) )
	elibc_Darwin? ( sys-libs/native-uuid )
	elibc_SunOS? ( sys-libs/libuuid )
"
DEPEND="
	${RDEPEND}
	test? ( dev-libs/json-c )
"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/gperf
	virtual/pkgconfig
	doc? (
		=app-text/docbook-sgml-dtd-3.1*
		app-text/docbook-sgml-utils[jadetex]
	)
	nls? ( >=sys-devel/gettext-0.19.8 )
"
PDEPEND="virtual/ttf-fonts"
# We need app-eselect/eselect-fontconfig in IDEPEND to update ROOT
# when cross-compiling.
IDEPEND="app-eselect/eselect-fontconfig"

PATCHES=(
	# bug #130466 + make liberation default
	"${FILESDIR}"/${PN}-2.14.0-latin-update.patch
	# Avoid test failure (bubblewrap doesn't work within sandbox)
	"${FILESDIR}"/${PN}-2.14.0-skip-bubblewrap-tests.patch

	# Patches from upstream (can usually be removed with next version bump)
	"${FILESDIR}"/${P}-fix-sysroot-fc-cache.patch
)

DOC_CONTENTS="Please make fontconfig configuration changes using
\`eselect fontconfig\`. Any changes made to /etc/fonts/fonts.conf will be
overwritten. If you need to reset your configuration to upstream defaults,
delete the directory ${EROOT}/etc/fonts/conf.d/ and re-emerge fontconfig."

src_prepare() {
	default

	# Test needs network access
	# https://gitlab.freedesktop.org/fontconfig/fontconfig/-/issues/319
	# On bumps, please check to see if this has been fixed
	# to allow local access!
	sed -i -e '/test-crbug1004254/d' test/meson.build || die
}

multilib_src_configure() {
	local addfonts=(
		"${EPREFIX}"/usr/local/share/fonts
	)

	# Harvest some font locations, such that users can benefit from the
	# host OS's installed fonts
	case ${CHOST} in
		*-darwin*)
			addfonts+=(
				/Library/Fonts
				/System/Library/Fonts
			)
		;;

		*-solaris*)
			[[ -d /usr/X/lib/X11/fonts/TrueType ]] && \
				addfonts+=( /usr/X/lib/X11/fonts/TrueType )
			[[ -d /usr/X/lib/X11/fonts/Type1 ]] &&
				addfonts+=( /usr/X/lib/X11/fonts/Type1 )
		;;

		*-linux-gnu)
			use prefix && [[ -d /usr/share/fonts ]] && \
				addfonts+=( /usr/share/fonts )
		;;
	esac

	local emesonargs=(
		# USE=doc only controls the additional bits like html/pdf
		# and regeneration of man pages from source. We always install
		# the prebuilt man pages.
		$(meson_native_use_feature doc)
		$(meson_native_use_feature doc doc-txt)
		$(meson_native_use_feature doc doc-html)
		$(meson_native_use_feature doc doc-man)
		$(meson_native_use_feature doc doc-pdf)

		$(meson_native_use_feature nls)
		$(meson_feature test tests)

		-Dcache-build=disabled
		-Dcache-dir="${EPREFIX}"/var/cache/fontconfig
		-Ddefault-fonts-dirs="${EPREFIX}"/usr/share/fonts
		-Dadditional-fonts-dirs=$(IFS=, ; echo "${addfonts[*]}" )
		-Dtemplate-dir="${EPREFIX}"/etc/fonts/conf.avail

		# Let users choose via eselect-fontconfig. See bug #900681
		# and https://gitlab.freedesktop.org/fontconfig/fontconfig/-/issues/356.
		-Ddefault-sub-pixel-rendering=none
	)

	meson_src_configure
}

multilib_src_install() {
	MULTILIB_CHOST_TOOLS=( /usr/bin/fc-cache$(get_exeext) )

	meson_src_install

	# Avoid calling this multiple times, bug #459210
	if multilib_is_native_abi; then
		insinto /etc/fonts
		doins fonts.conf
	fi
}

multilib_src_install_all() {
	einstalldocs

	# fc-lang directory contains language coverage datafiles
	# which are needed to test the coverage of fonts.
	insinto /usr/share/fc-lang
	doins fc-lang/*.orth

	dodoc doc/fontconfig-user.{txt,pdf}

	if ! use doc ; then
		find "${S}" -name "*.[[:digit:]]" -type f -exec doman '{}' + || die
	fi

	if [[ -e ${ED}/usr/share/doc/fontconfig/ ]] ;  then
		mv "${ED}"/usr/share/doc/fontconfig/* "${ED}"/usr/share/doc/${PF} || die
		rm -rf "${ED}"/usr/share/doc/fontconfig || die
	fi

	# Changes should be made to /etc/fonts/local.conf, and as we had
	# too much problems with broken fonts.conf we force update it ...
	echo 'CONFIG_PROTECT_MASK="/etc/fonts/fonts.conf"' > "${T}"/37fontconfig || die
	doenvd "${T}"/37fontconfig

	# As of fontconfig 2.7, everything sticks their noses in here.
	dodir /etc/sandbox.d
	echo 'SANDBOX_PREDICT="/var/cache/fontconfig"' > "${ED}"/etc/sandbox.d/37fontconfig || die

	readme.gentoo_create_doc
}

pkg_preinst() {
	# bug #193476
	# /etc/fonts/conf.d/ contains symlinks to ../conf.avail/ to include various
	# config files.  If we install as-is, we'll blow away user settings.
	ebegin "Syncing fontconfig configuration to system"
	if [[ -e ${EROOT}/etc/fonts/conf.d ]] ; then
		local file f
		for file in "${EROOT}"/etc/fonts/conf.avail/* ; do
			f=${file##*/}
			if [[ -L ${EROOT}/etc/fonts/conf.d/${f} ]] ; then
				[[ -f ${ED}/etc/fonts/conf.avail/${f} ]] \
					&& ln -sf ../conf.avail/"${f}" \
						"${ED}"/etc/fonts/conf.d/ &>/dev/null
			else
				[[ -f ${ED}/etc/fonts/conf.avail/${f} ]] \
					&& rm "${ED}"/etc/fonts/conf.d/"${f}" &>/dev/null
			fi
		done
	fi
	eend $?
}

pkg_postinst() {
	einfo "Cleaning broken symlinks in ${EROOT}/etc/fonts/conf.d/"
	find -L "${EROOT}"/etc/fonts/conf.d/ -type l -delete

	readme.gentoo_print_elog

	local ver
	for ver in ${REPLACING_VERSIONS} ; do
		# 2.14.2 and 2.14.2-r1 included the bad 10-sub-pixel-none.conf
		if ver_test ${ver} -lt 2.14.2-r2 && ver_test ${ver} -ge 2.14.2 ; then
			if [[ -e "${EROOT}"/etc/fonts/conf.d/10-sub-pixel-none.conf ]] ; then
				einfo "Deleting 10-sub-pixel-none.conf from bad fontconfig-2.14.2 (bug #900681)"
				rm "${EROOT}"/etc/fonts/conf.d/10-sub-pixel-none.conf || die
			fi
		fi
	done

	if [[ -z ${ROOT} ]] ; then
		multilib_pkg_postinst() {
			ebegin "Creating global font cache for ${ABI}"
			"${EPREFIX}"/usr/bin/${CHOST}-fc-cache -srf
			eend $?
		}

		multilib_parallel_foreach_abi multilib_pkg_postinst
	fi
}
