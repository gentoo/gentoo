# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Cannot yet migrate to Meson as of 2.14.0:
# https://gitlab.freedesktop.org/fontconfig/fontconfig/-/issues/244
inherit autotools multilib-minimal readme.gentoo-r1

DESCRIPTION="A library for configuring and customizing font access"
HOMEPAGE="https://fontconfig.org/"
SRC_URI="https://fontconfig.org/release/${P}.tar.xz"

LICENSE="MIT"
SLOT="1.0"
if ! [[ $(ver_cut 3) -ge 90 ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
fi
IUSE="doc static-libs test"
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
RDEPEND=">=dev-libs/expat-2.1.0-r3[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.9.1[${MULTILIB_USEDEP}]
	!elibc_Darwin? ( !elibc_SunOS? ( sys-apps/util-linux[${MULTILIB_USEDEP}] ) )
	elibc_Darwin? ( sys-libs/native-uuid )
	elibc_SunOS? ( sys-libs/libuuid )
	virtual/libintl[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-libs/json-c )"
BDEPEND="dev-util/gperf
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	doc? (
		=app-text/docbook-sgml-dtd-3.1*
		app-text/docbook-sgml-utils[jadetex]
	)"
PDEPEND="virtual/ttf-fonts"
# We need app-eselect/eselect-fontconfig in IDEPEND to update ROOT
# when cross-compiling.
IDEPEND="!x86-winnt? ( app-eselect/eselect-fontconfig )"

PATCHES=(
	# bug #310157
	"${FILESDIR}"/${PN}-2.14.0-docbook.patch
	# bug #130466 + make liberation default
	"${FILESDIR}"/${PN}-2.14.0-latin-update.patch
	# Avoid test failure (bubblewrap doesn't work within sandbox)
	"${FILESDIR}"/${PN}-2.14.0-skip-bubblewrap-tests.patch

	# Patches from upstream (can usually be removed with next version bump)
)

DOC_CONTENTS="Please make fontconfig configuration changes using
\`eselect fontconfig\`. Any changes made to /etc/fonts/fonts.conf will be
overwritten. If you need to reset your configuration to upstream defaults,
delete the directory ${EROOT}/etc/fonts/conf.d/ and re-emerge fontconfig."

src_prepare() {
	default

	# Needed for docbook patch
	eautoreconf
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

	local myeconfargs=(
		$(use_enable doc docbook)
		$(use_enable static-libs static)

		# man pages. We split out the docbook parts into its own flag.
		--enable-docs
		# We handle this ourselves.
		--disable-cache-build
		# See comment above *DEPEND. We use Expat instead.
		--disable-libxml2

		--localstatedir="${EPREFIX}"/var
		--with-default-fonts="${EPREFIX}"/usr/share/fonts
		--with-add-fonts=$(IFS=, ; echo "${addfonts[*]}" )
		--with-templatedir="${EPREFIX}"/etc/fonts/conf.avail
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_test() {
	# Test needs network access
	# https://gitlab.freedesktop.org/fontconfig/fontconfig/-/issues/319
	# On bumps after 2.14.0, please check to see if this has been fixed
	# to allow local access!
	chmod -x test/test-crbug1004254 || die

	default
}

multilib_src_install() {
	MULTILIB_CHOST_TOOLS=( /usr/bin/fc-cache$(get_exeext) )

	default

	# Avoid calling this multiple times, bug #459210
	if multilib_is_native_abi; then
		# Stuff installed from build-dir
		emake -C doc DESTDIR="${D}" install-man

		insinto /etc/fonts
		doins fonts.conf
	fi
}

multilib_src_install_all() {
	einstalldocs

	find "${ED}" -name "*.la" -delete || die

	# fc-lang directory contains language coverage datafiles
	# which are needed to test the coverage of fonts.
	insinto /usr/share/fc-lang
	doins fc-lang/*.orth

	dodoc doc/fontconfig-user.{txt,pdf}

	if [[ -e ${ED}/usr/share/doc/fontconfig/ ]] ;  then
		mv "${ED}"/usr/share/doc/fontconfig/* \
			"${ED}"/usr/share/doc/${P} || die
		rm -rf "${ED}"/usr/share/doc/fontconfig || die
	fi

	# Changes should be made to /etc/fonts/local.conf, and as we had
	# too much problems with broken fonts.conf we force update it ...
	echo 'CONFIG_PROTECT_MASK="/etc/fonts/fonts.conf"' \
		> "${T}"/37fontconfig || die
	doenvd "${T}"/37fontconfig

	# As of fontconfig 2.7, everything sticks their noses in here.
	dodir /etc/sandbox.d
	echo 'SANDBOX_PREDICT="/var/cache/fontconfig"' \
		> "${ED}"/etc/sandbox.d/37fontconfig || die

	readme.gentoo_create_doc

	# We allow the cache generation to make this later
	# bug #587492
	rm -r "${ED}"/var/cache/fontconfig || die
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

	if [[ -z ${ROOT} ]] ; then
		multilib_pkg_postinst() {
			ebegin "Creating global font cache for ${ABI}"
			"${EPREFIX}"/usr/bin/${CHOST}-fc-cache -srf
			eend $?
		}

		multilib_parallel_foreach_abi multilib_pkg_postinst
	fi
}
