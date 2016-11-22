# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils multilib toolchain-funcs

MISCSPLASH="miscsplashutils-0.1.8"
GENTOOSPLASH="splashutils-gentoo-1.0.17"
V_JPEG="8a"
V_PNG="1.4.3"
V_ZLIB="1.2.3"
V_FT="2.3.12"

ZLIBSRC="libs/zlib-${V_ZLIB}"
LPNGSRC="libs/libpng-${V_PNG}"
JPEGSRC="libs/jpeg-${V_JPEG}"
FT2SRC="libs/freetype-${V_FT}"

RESTRICT="test"
IUSE="hardened +png +truetype gpm fbcondecor"

DESCRIPTION="Framebuffer splash utilities"
HOMEPAGE="https://sourceforge.net/projects/fbsplash.berlios/"
SRC_URI="
	mirror://sourceforge/fbsplash.berlios/${PN}-lite-${PV}.tar.bz2
	mirror://sourceforge/fbsplash.berlios/${GENTOOSPLASH}.tar.bz2
	mirror://gentoo/${MISCSPLASH}.tar.bz2
	mirror://sourceforge/libpng/libpng-${V_PNG}.tar.bz2
	ftp://ftp.uu.net/graphics/jpeg/jpegsrc.v${V_JPEG}.tar.gz
	mirror://sourceforge/freetype/freetype-${V_FT}.tar.bz2
	http://www.gzip.org/zlib/zlib-${V_ZLIB}.tar.bz2
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"

RDEPEND="
	gpm? ( sys-libs/gpm[static-libs(+)] )
	truetype? (
		>=media-libs/freetype-2[static-libs]
		app-arch/bzip2[static-libs(+)]
		sys-libs/zlib[static-libs(+)]
	)
	png? (
		>=media-libs/libpng-1.4.3[static-libs]
		sys-libs/zlib[static-libs(+)]
	)
	virtual/jpeg:0[static-libs]
	app-arch/cpio
	media-gfx/fbgrab
	!sys-apps/lcdsplash
	sys-apps/openrc"

DEPEND="${RDEPEND}
	>=dev-libs/klibc-1.5
	virtual/pkgconfig
"

S="${WORKDIR}/${P/_/-}"
SG="${WORKDIR}/${GENTOOSPLASH}"
SM="${WORKDIR}/${MISCSPLASH}"

pkg_setup() {
	if use hardened; then
		ewarn "Due to problems with klibc, it is currently impossible to compile splashutils"
		ewarn "with 'hardened' GCC flags. As a workaround, the package will be compiled with"
		ewarn "-fno-stack-protector. Hardened GCC features will not be used while building"
		ewarn "the splash kernel helper."
	fi
}

src_prepare() {
	mv "${WORKDIR}"/{libpng-${V_PNG},jpeg-${V_JPEG},zlib-${V_ZLIB},freetype-${V_FT}} "${S}/libs"

	# We need to delete the Makefile and let it be rebuilt when splashutils
	# is being configured. Either that, or we end up with a segfaulting kernel
	# helper.
	rm "${S}/libs/zlib-${V_ZLIB}/Makefile"

	cd "${SG}"
	epatch "${FILESDIR}/splashutils-1.5.4.4-gentoo-typo-fix.patch"
	epatch "${FILESDIR}/splashutils-1.5.4.4-sys-queue.patch"

	if use truetype ; then
		cd "${SM}"
		epatch "${FILESDIR}/splashutils-1.5.4.4-freetype-bz2.patch"
		cd "${WORKDIR}"
		epatch "${FILESDIR}/splashutils-1.5.4.4-ft25.patch"
	fi

	cd "${S}"
	ln -sf "${S}/src" "${WORKDIR}/core"

	#epatch "${FILESDIR}/${P}-bzip2.patch"
	epatch "${FILESDIR}/${P}-multi-keyboard.patch"
	# Bug #557126
	epatch "${FILESDIR}/${P}-no-la.patch"

	if ! tc-is-cross-compiler && \
	   has_version "sys-devel/gcc:$(gcc-version)[vanilla]" ; then
		ewarn "Your GCC was built with the 'vanilla' flag set. If you can't compile"
		ewarn "splashutils, you're on your own, as this configuration is not supported."
	else
		# This should make splashutils compile on systems with hardened GCC.
		sed -e 's@K_CFLAGS =@K_CFLAGS = -fno-stack-protector@' -i "${S}/Makefile.in"
	fi

	if ! use truetype ; then
		sed -i -e 's/fbtruetype kbd/kbd/' "${SM}/Makefile"
	fi

	# Latest version of klibc defined its own version of ferror, so there is
	# not need for the hack in klibc_compat.h
	if has_version ">=dev-libs/klibc-1.5.20"; then
		echo > "libs/klibc_compat.h"
	fi

	rm -f m4/*
	epatch_user
	export PKG_CONFIG="pkg-config --static"
	eautoreconf
}

src_configure() {
	tc-export CC
	cd "${SM}"
	emake CC="${CC}" LIB=$(get_libdir) STRIP=true

	cd "${S}"
	econf \
		$(use_with png) \
		--without-mng \
		$(use_with gpm) \
		$(use_with truetype ttf) \
		$(use_with truetype ttf-kernel) \
		$(use_enable fbcondecor) \
		--docdir=/usr/share/doc/${PF} \
		--with-freetype2-src=${FT2SRC} \
		--with-jpeg-src=${JPEGSRC} \
		--with-lpng-src=${LPNGSRC} \
		--with-zlib-src=${ZLIBSRC} \
		--with-essential-libdir=/$(get_libdir)
}

src_compile() {
	emake CC="${CC}" STRIP="true"

	cd "${SG}"
	emake LIB=$(get_libdir)
}

src_install() {
	local LIB=$(get_libdir)

	cd "${SM}"
	emake DESTDIR="${D}" LIB=${LIB} install

	cd "${S}"
	emake DESTDIR="${D}" STRIP="true" install

	mv "${D}"/usr/${LIB}/libfbsplash.so* "${D}"/${LIB}/
	gen_usr_ldscript libfbsplash.so

	echo 'CONFIG_PROTECT_MASK="/etc/splash"' > 99splash
	doenvd 99splash

	if use fbcondecor ; then
		newinitd "${SG}"/init-fbcondecor fbcondecor
		newconfd "${SG}"/fbcondecor.conf fbcondecor
	fi
	newconfd "${SG}"/splash.conf splash

	insinto /usr/share/${PN}
	doins "${SG}"/initrd.splash

	insinto /etc/splash
	doins "${SM}"/fbtruetype/luxisri.ttf

	cd "${SG}"
	make DESTDIR="${D}" LIB=${LIB} install
	prune_libtool_files

	sed -i -e "s#/lib/splash#/${LIB}/splash#" "${D}"/sbin/splash-functions.sh
	keepdir /${LIB}/splash/{tmp,cache,bin,sys}
	dosym /${LIB}/splash/bin/fbres /sbin/fbres
}

pkg_preinst() {
	has_version "<${CATEGORY}/${PN}-1.0"
	previous_less_than_1_0=$?

	has_version "<${CATEGORY}/${PN}-1.5.3"
	previous_less_than_1_5_3=$?
}

pkg_postinst() {
	if has_version sys-fs/devfsd || ! has_version virtual/udev ; then
		elog "This package has been designed with udev in mind. Other solutions, such as"
		elog "devfs or a static /dev tree might work, but are generally discouraged and"
		elog "not supported. If you decide to switch to udev, you might want to have a"
		elog "look at 'The Gentoo udev Guide', which can be found at"
		elog "  https://wiki.gentoo.org/wiki/Udev"
		elog ""
	fi

	if [[ $previous_less_than_1_0 = 0 ]] ; then
		elog "Since you are upgrading from a pre-1.0 version, please make sure that you"
		elog "rebuild your initrds. You can use the splash_geninitramfs script to do that."
		elog ""
	fi

	if [[ $previous_less_than_1_5_3 = 0 ]] && ! use fbcondecor ; then
		elog "Starting with splashutils-1.5.3, support for the fbcondecor kernel patch"
		elog "is optional and dependent on the the 'fbcondecor' USE flag.  If you wish"
		elog "to use fbcondecor, run:"
		elog "  echo \"media-gfx/splashutils fbcondecor\" >> /etc/portage/package.use"
		elog "and re-emerge splashutils."
	fi

	if ! test -f /proc/cmdline ||
		! egrep -q '(console=tty1|CONSOLE=/dev/tty1)' /proc/cmdline ; then
		elog "It is required that you add 'console=tty1' to your kernel"
		elog "command line parameters."
		elog ""
		elog "After these modifications, the relevant part of the kernel command"
		elog "line might look like:"
		elog "  splash=silent,fadein,theme:emergence console=tty1"
		elog ""
	fi

	if ! has_version 'media-gfx/splash-themes-livecd' &&
		! has_version 'media-gfx/splash-themes-gentoo'; then
		elog "The sample Gentoo themes (emergence, gentoo) have been removed from the"
		elog "core splashutils package. To get some themes you might want to emerge:"
		elog "  media-gfx/splash-themes-livecd"
		elog "  media-gfx/splash-themes-gentoo"
	fi
}
