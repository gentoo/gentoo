# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multilib-minimal readme.gentoo-r1 eapi7-ver

DESCRIPTION="A library for configuring and customizing font access"
HOMEPAGE="https://fontconfig.org/"
SRC_URI="https://fontconfig.org/release/${P}.tar.bz2"

LICENSE="MIT"
SLOT="1.0"
[[ $(ver_cut 3) -ge 90 ]] || \
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc static-libs"

# Purposefully dropped the xml USE flag and libxml2 support.  Expat is the
# default and used by every distro.  See bug #283191.
RDEPEND=">=dev-libs/expat-2.1.0-r3[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.9[${MULTILIB_USEDEP}]
	!elibc_Darwin? ( sys-apps/util-linux[${MULTILIB_USEDEP}] )
	elibc_Darwin? ( sys-libs/native-uuid )
	virtual/libintl[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-devel/gettext-0.19.8
	doc? ( =app-text/docbook-sgml-dtd-3.1*
		app-text/docbook-sgml-utils[jadetex] )"
PDEPEND="!x86-winnt? ( app-eselect/eselect-fontconfig )
	virtual/ttf-fonts"

PATCHES=(
	"${FILESDIR}"/${PN}-2.10.2-docbook.patch # 310157
	"${FILESDIR}"/${PN}-2.12.3-latin-update.patch # 130466 + make liberation default
	"${FILESDIR}"/${P}-locale.patch #650332
	"${FILESDIR}"/${P}-names.patch #650370
	"${FILESDIR}"/${P}-add-missing-lintl.patch #652674
)

MULTILIB_CHOST_TOOLS=( /usr/bin/fc-cache$(get_exeext) )

pkg_setup() {
	DOC_CONTENTS="Please make fontconfig configuration changes using
	\`eselect fontconfig\`. Any changes made to /etc/fonts/fonts.conf will be
	overwritten. If you need to reset your configuration to upstream defaults,
	delete the directory ${EROOT%/}/etc/fonts/conf.d/ and re-emerge fontconfig."
}

src_prepare() {
	default
	export GPERF=$(type -P true)  # avoid dependency on gperf, #631980
	sed -i -e 's/FC_GPERF_SIZE_T="unsigned int"/FC_GPERF_SIZE_T=size_t/' \
		configure.ac || die # rest of gperf dependency fix, #631920
	eautoreconf
	rm test/out.expected || die #662048
}

multilib_src_configure() {
	local addfonts
	# harvest some font locations, such that users can benefit from the
	# host OS's installed fonts
	case ${CHOST} in
		*-darwin*)
			addfonts=",/Library/Fonts,/System/Library/Fonts"
		;;
		*-solaris*)
			[[ -d /usr/X/lib/X11/fonts/TrueType ]] && \
				addfonts=",/usr/X/lib/X11/fonts/TrueType"
			[[ -d /usr/X/lib/X11/fonts/Type1 ]] && \
				addfonts="${addfonts},/usr/X/lib/X11/fonts/Type1"
		;;
		*-linux-gnu)
			use prefix && [[ -d /usr/share/fonts ]] && \
				addfonts=",/usr/share/fonts"
		;;
	esac

	local myeconfargs=(
		$(use_enable doc docbook)
		$(use_enable static-libs static)
		--enable-docs
		--localstatedir="${EPREFIX}"/var
		--with-default-fonts="${EPREFIX}"/usr/share/fonts
		--with-add-fonts="${EPREFIX}/usr/local/share/fonts${addfonts}"
		--with-templatedir="${EPREFIX}"/etc/fonts/conf.avail
	)

	ECONF_SOURCE="${S}" \
	econf "${myeconfargs[@]}"
}

multilib_src_install() {
	default

	# avoid calling this multiple times, bug #459210
	if multilib_is_native_abi; then
		# stuff installed from build-dir
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

	if [[ -e ${ED}usr/share/doc/fontconfig/ ]];  then
		mv "${ED}"usr/share/doc/fontconfig/* "${ED}"/usr/share/doc/${P} || die
		rm -rf "${ED}"usr/share/doc/fontconfig
	fi

	# Changes should be made to /etc/fonts/local.conf, and as we had
	# too much problems with broken fonts.conf we force update it ...
	echo 'CONFIG_PROTECT_MASK="/etc/fonts/fonts.conf"' > "${T}"/37fontconfig
	doenvd "${T}"/37fontconfig

	# As of fontconfig 2.7, everything sticks their noses in here.
	dodir /etc/sandbox.d
	echo 'SANDBOX_PREDICT="/var/cache/fontconfig"' > "${ED}"/etc/sandbox.d/37fontconfig

	readme.gentoo_create_doc
}

pkg_preinst() {
	# Bug #193476
	# /etc/fonts/conf.d/ contains symlinks to ../conf.avail/ to include various
	# config files.  If we install as-is, we'll blow away user settings.
	ebegin "Syncing fontconfig configuration to system"
	if [[ -e ${EROOT}/etc/fonts/conf.d ]]; then
		for file in "${EROOT}"/etc/fonts/conf.avail/*; do
			f=${file##*/}
			if [[ -L ${EROOT}/etc/fonts/conf.d/${f} ]]; then
				[[ -f ${ED}etc/fonts/conf.avail/${f} ]] \
					&& ln -sf ../conf.avail/"${f}" "${ED}"etc/fonts/conf.d/ &>/dev/null
			else
				[[ -f ${ED}etc/fonts/conf.avail/${f} ]] \
					&& rm "${ED}"etc/fonts/conf.d/"${f}" &>/dev/null
			fi
		done
	fi
	eend $?
}

pkg_postinst() {
	einfo "Cleaning broken symlinks in ${EROOT%/}/etc/fonts/conf.d/"
	find -L "${EROOT}"etc/fonts/conf.d/ -type l -delete

	readme.gentoo_print_elog

	if [[ ${ROOT} = / ]]; then
		multilib_pkg_postinst() {
			ebegin "Creating global font cache for ${ABI}"
			"${EPREFIX}"/usr/bin/${CHOST}-fc-cache -srf
			eend $?
		}

		multilib_parallel_foreach_abi multilib_pkg_postinst
	fi
}
