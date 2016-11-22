# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
GRUB_AUTOGEN=1

if [[ -n ${GRUB_AUTOGEN} ]]; then
	PYTHON_COMPAT=( python{2_7,3_3,3_4} )
	inherit python-any-r1
fi

inherit autotools-utils bash-completion-r1 eutils flag-o-matic mount-boot multibuild pax-utils toolchain-funcs versionator

if [[ ${PV} != 9999 ]]; then
	if [[ ${PV} == *_alpha* || ${PV} == *_beta* || ${PV} == *_rc* ]]; then
		# The quote style is to work with <=bash-4.2 and >=bash-4.3 #503860
		MY_P=${P/_/'~'}
		SRC_URI="mirror://gnu-alpha/${PN}/${MY_P}.tar.xz
			https://dev.gentoo.org/~floppym/dist/${P}-gentoo-r3.tar.xz"
		S=${WORKDIR}/${MY_P}
	else
		SRC_URI="mirror://gnu/${PN}/${P}.tar.xz
			https://dev.gentoo.org/~floppym/dist/${P}.tar.xz"
		S=${WORKDIR}/${P%_*}
	fi
	KEYWORDS="amd64 x86"
else
	inherit git-r3
	EGIT_REPO_URI="git://git.sv.gnu.org/grub.git
		http://git.savannah.gnu.org/r/grub.git"
fi

DEJAVU=dejavu-sans-ttf-2.34
UNIFONT=unifont-7.0.06
SRC_URI+=" fonts? ( mirror://gnu/unifont/${UNIFONT}/${UNIFONT}.pcf.gz )
	themes? ( mirror://sourceforge/dejavu/${DEJAVU}.zip )"

DESCRIPTION="GNU GRUB boot loader"
HOMEPAGE="https://www.gnu.org/software/grub/"

# Includes licenses for dejavu and unifont
LICENSE="GPL-3 fonts? ( GPL-2-with-font-exception ) themes? ( BitstreamVera )"
SLOT="2/${PVR}"
IUSE="debug device-mapper doc efiemu +fonts mount multislot nls static sdl test +themes truetype libzfs"

GRUB_ALL_PLATFORMS=( coreboot efi-32 efi-64 emu ieee1275 loongson multiboot qemu qemu-mips pc uboot xen )
IUSE+=" ${GRUB_ALL_PLATFORMS[@]/#/grub_platforms_}"

REQUIRED_USE="
	grub_platforms_coreboot? ( fonts )
	grub_platforms_qemu? ( fonts )
	grub_platforms_ieee1275? ( fonts )
	grub_platforms_loongson? ( fonts )
"

# os-prober: Used on runtime to detect other OSes
# xorriso (dev-libs/libisoburn): Used on runtime for mkrescue
RDEPEND="
	app-arch/xz-utils
	>=sys-libs/ncurses-5.2-r5:0=
	debug? (
		sdl? ( media-libs/libsdl )
	)
	device-mapper? ( >=sys-fs/lvm2-2.02.45 )
	libzfs? ( sys-fs/zfs )
	mount? ( sys-fs/fuse )
	truetype? ( media-libs/freetype:2= )
	ppc? ( sys-apps/ibm-powerpc-utils sys-apps/powerpc-utils )
	ppc64? ( sys-apps/ibm-powerpc-utils sys-apps/powerpc-utils )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	app-misc/pax-utils
	sys-devel/flex
	sys-devel/bison
	sys-apps/help2man
	sys-apps/texinfo
	fonts? ( media-libs/freetype:2 )
	grub_platforms_xen? ( app-emulation/xen-tools:= )
	static? (
		app-arch/xz-utils[static-libs(+)]
		truetype? (
			app-arch/bzip2[static-libs(+)]
			media-libs/freetype[static-libs(+)]
			sys-libs/zlib[static-libs(+)]
		)
	)
	test? (
		dev-libs/libisoburn
		app-emulation/qemu
	)
	themes? (
		app-arch/unzip
		media-libs/freetype:2
	)
"
RDEPEND+="
	kernel_linux? (
		grub_platforms_efi-32? ( sys-boot/efibootmgr )
		grub_platforms_efi-64? ( sys-boot/efibootmgr )
	)
	!multislot? ( !sys-boot/grub:0 !sys-boot/grub-static )
	nls? ( sys-devel/gettext )
"

DEPEND+=" !!=media-libs/freetype-2.5.4"

STRIP_MASK="*/grub/*/*.{mod,img}"
RESTRICT="test"

QA_EXECSTACK="
	usr/bin/grub*-emu*
	usr/lib*/grub/*/*.mod
	usr/lib*/grub/*/*.module
	usr/lib*/grub/*/kernel.exec
	usr/lib*/grub/*/kernel.img
"

QA_WX_LOAD="
	usr/lib*/grub/*/kernel.exec
	usr/lib*/grub/*/kernel.img
	usr/lib*/grub/*/*.image
"

QA_PRESTRIPPED="
	usr/lib.*/grub/.*/kernel.img
"

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	fi
	default_src_unpack
}

src_prepare() {
	EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" epatch

	epatch "${FILESDIR}"/CVE-2015-8370.patch
	epatch "${FILESDIR}"/${P}-lvm2-raid1.patch
	epatch "${FILESDIR}"/${P}-KERNEL_GLOBS.patch

	sed -i -e /autoreconf/d autogen.sh || die

	if use multislot; then
		# fix texinfo file name, bug 416035
		sed -i -e 's/^\* GRUB:/* GRUB2:/' -e 's/(grub)/(grub2)/' docs/grub.texi || die
	fi

	epatch_user

	if [[ -n ${GRUB_AUTOGEN} ]]; then
		python_setup
		bash autogen.sh || die
	fi

	if [[ -n ${AUTOTOOLS_AUTORECONF} ]]; then
		autopoint() { return 0; }
		eautoreconf
	fi
}

setup_fonts() {
	ln -s "${WORKDIR}/${UNIFONT}.pcf" unifont.pcf || die
	if use themes; then
		ln -s "${WORKDIR}/${DEJAVU}/ttf/DejaVuSans.ttf" DejaVuSans.ttf || die
	fi
}

grub_configure() {
	local platform

	case ${MULTIBUILD_VARIANT} in
		efi-32)
			platform=efi
			if [[ ${CTARGET:-${CHOST}} == x86_64* ]]; then
				local CTARGET=${CTARGET:-i386}
			fi ;;
		efi-64)
			platform=efi
			if [[ ${CTARGET:-${CHOST}} == i?86* ]]; then
				local CTARGET=${CTARGET:-x86_64}
				local TARGET_CFLAGS="-Os -march=x86-64 ${TARGET_CFLAGS}"
				local TARGET_CPPFLAGS="-march=x86-64 ${TARGET_CPPFLAGS}"
				export TARGET_CFLAGS TARGET_CPPFLAGS
			fi ;;
		guessed) ;;
		*)	platform=${MULTIBUILD_VARIANT} ;;
	esac

	local myeconfargs=(
		--disable-werror
		--program-prefix=
		--libdir="${EPREFIX}"/usr/lib
		--htmldir="${EPREFIX}"/usr/share/doc/${PF}/html
		$(use_enable debug mm-debug)
		$(use_enable debug grub-emu-usb)
		$(use_enable device-mapper)
		$(use_enable mount grub-mount)
		$(use_enable nls)
		$(use_enable themes grub-themes)
		$(use_enable truetype grub-mkfont)
		$(use_enable libzfs)
		$(use sdl && use_enable debug grub-emu-sdl)
		${platform:+--with-platform=}${platform}

		# Let configure detect this where supported
		$(usex efiemu '' '--disable-efiemu')
	)

	if use multislot; then
		myeconfargs+=( --program-transform-name="s,grub,grub2," )
	fi

	mkdir -p "${BUILD_DIR}" || die
	run_in_build_dir setup_fonts

	autotools-utils_src_configure
}

src_configure() {
	# Bug 508758.
	replace-flags -O3 -O2

	# We don't want to leak flags onto boot code.
	export HOST_CCASFLAGS=${CCASFLAGS}
	export HOST_CFLAGS=${CFLAGS}
	export HOST_CPPFLAGS=${CPPFLAGS}
	export HOST_LDFLAGS=${LDFLAGS}
	unset CCASFLAGS CFLAGS CPPFLAGS LDFLAGS

	use static && HOST_LDFLAGS+=" -static"

	tc-ld-disable-gold #439082 #466536 #526348
	export TARGET_LDFLAGS="${TARGET_LDFLAGS} ${LDFLAGS}"
	unset LDFLAGS

	tc-export CC NM OBJCOPY RANLIB STRIP
	tc-export BUILD_CC # Bug 485592

	# Portage will take care of cleaning up GRUB_PLATFORMS
	MULTIBUILD_VARIANTS=( ${GRUB_PLATFORMS:-guessed} )
	multibuild_parallel_foreach_variant grub_configure
}

src_compile() {
	# Sandbox bug 404013.
	use libzfs && addpredict /etc/dfs:/dev/zfs

	multibuild_foreach_variant autotools-utils_src_compile

	use doc && multibuild_for_best_variant \
		autotools-utils_src_compile -C docs html
}

src_test() {
	# The qemu dependency is a bit complex.
	# You will need to adjust QEMU_SOFTMMU_TARGETS to match the cpu/platform.
	multibuild_foreach_variant autotools-utils_src_test
}

src_install() {
	multibuild_foreach_variant autotools-utils_src_install \
		bashcompletiondir="$(get_bashcompdir)"

	local grub=grub
	if use multislot; then
		grub=grub2
		mv "${ED%/}"/usr/share/info/grub{,2}.info || die
		mv "${ED%/}"/$(get_bashcompdir)/grub{,2} || die
	fi

	bashcomp_alias ${grub} ${grub}-{install,set-default,mkrescue,reboot,script-check,editenv,sparc64-setup,mkfont,mkpasswd-pbkdf2,mkimage,bios-setup,mkconfig,probe}

	use doc && multibuild_for_best_variant run_in_build_dir \
		emake -C docs DESTDIR="${D}" install-html

	insinto /etc/default
	newins "${FILESDIR}"/grub.default-3 grub
}

pkg_postinst() {
	mount-boot_mount_boot_partition

	if [[ -e "${ROOT%/}/boot/grub2/grub.cfg"  ]]; then
		ewarn "The grub directory has changed from /boot/grub2 to /boot/grub."
		ewarn "Please run $(usex multislot grub2 grub)-install and $(usex multislot grub2 grub)-mkconfig -o /boot/grub/grub.cfg."

		if [[ ! -e "${ROOT%/}/boot/grub/grub.cfg" ]]; then
			mkdir -p "${ROOT%/}/boot/grub"
			ln -s ../grub2/grub.cfg "${ROOT%/}/boot/grub/grub.cfg"
		fi
	fi

	mount-boot_pkg_postinst

	elog "For information on how to configure GRUB2 please refer to the guide:"
	elog "    https://wiki.gentoo.org/wiki/GRUB2_Quick_Start"

	if has_version 'sys-boot/grub:0'; then
		elog "A migration guide for GRUB Legacy users is available:"
		elog "    https://wiki.gentoo.org/wiki/GRUB2_Migration"
	fi

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog
		elog "You may consider installing the following optional packages:"
		optfeature "Detect other operating systems (grub-mkconfig)" sys-boot/os-prober
		optfeature "Create rescue media (grub-mkrescue)" dev-libs/libisoburn
		optfeature "Enable RAID device detection" sys-fs/mdadm
	else
		local v
		for v in ${REPLACING_VERSIONS}; do
			if ! version_is_at_least 2.02_beta2-r8 ${v}; then
				ewarn "Please re-run $(usex multislot grub2 grub)-install to address a security flaw when using"
				ewarn "username/password authentication in grub."
				ewarn "See bug 568326 for more information."
			fi
		done
	fi
}
