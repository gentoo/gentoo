# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='xml,threads'

inherit flag-o-matic eutils multilib python-single-r1 toolchain-funcs

XEN_EXTFILES_URL="http://xenbits.xensource.com/xen-extfiles"
LIBPCI_URL=ftp://atrey.karlin.mff.cuni.cz/pub/linux/pci
GRUB_URL=mirror://gnu-alpha/grub
SRC_URI="
		http://bits.xensource.com/oss-xen/release/${PV}/xen-${PV}.tar.gz
		$GRUB_URL/grub-0.97.tar.gz
		$XEN_EXTFILES_URL/zlib-1.2.3.tar.gz
		$LIBPCI_URL/pciutils-2.2.9.tar.bz2
		$XEN_EXTFILES_URL/lwip-1.3.0.tar.gz
		$XEN_EXTFILES_URL/newlib/newlib-1.16.0.tar.gz
		$XEN_EXTFILES_URL/polarssl-1.1.4-gpl.tgz"

S="${WORKDIR}/xen-${PV}"

DESCRIPTION="allows to boot Xen domU kernels from a menu.lst laying inside guest filesystem"
HOMEPAGE="http://xen.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="custom-cflags"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="sys-devel/gettext
	sys-devel/bin86
	sys-apps/texinfo
	x11-libs/pixman"

RDEPEND=">=app-emulation/xen-tools-${PV}"

pkg_setup() {
	python-single-r1_pkg_setup
}

retar-externals() {
	# Purely to unclutter src_prepare
	local set="grub-0.97.tar.gz lwip-1.3.0.tar.gz newlib-1.16.0.tar.gz polarssl-1.1.4-gpl.tgz zlib-1.2.3.tar.gz"

	# epatch can't patch in $WORKDIR, requires a sed; Bug #455194. Patchable, but sed informative
	sed -e s':AR=${AR-"ar rc"}:AR=${AR-"ar"}:' \
		-i "${WORKDIR}"/zlib-1.2.3/configure
	sed -e 's:^AR=ar rc:AR=ar:' \
		-e s':$(AR) $@:$(AR) rc $@:' \
		-i "${WORKDIR}"/zlib-1.2.3/{Makefile,Makefile.in}
	einfo "zlib Makefile edited"

	cd "${WORKDIR}"
	tar czp zlib-1.2.3 -f zlib-1.2.3.tar.gz
	tar czp grub-0.97 -f grub-0.97.tar.gz
	tar czp lwip -f lwip-1.3.0.tar.gz
	tar czp newlib-1.16.0 -f newlib-1.16.0.tar.gz
	tar czp polarssl-1.1.4 -f polarssl-1.1.4-gpl.tgz
	mv $set "${S}"/stubdom/
	einfo "tarballs moved to source"
}

src_prepare() {
	# if the user *really* wants to use their own custom-cflags, let them
	if use custom-cflags; then
		einfo "User wants their own CFLAGS - removing defaults"
		# try and remove all the default custom-cflags
		find "${S}" -name Makefile -o -name Rules.mk -o -name Config.mk -exec sed \
			-e 's/CFLAGS\(.*\)=\(.*\)-O3\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-march=i686\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-fomit-frame-pointer\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-g3*\s\(.*\)/CFLAGS\1=\2 \3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-O2\(.*\)/CFLAGS\1=\2\3/' \
			-i {} \;
	fi

	# Patch the unmergeable newlib, fix most of the leftover gcc QA issues
	cp "${FILESDIR}"/newlib-implicits.patch stubdom || die

	# Patch stubdom/Makefile to patch insource newlib & prevent internal downloading
	epatch "${FILESDIR}"/${PN/-pvgrub/}-4.3-externals.patch

	# fix jobserver in Makefile
	epatch "${FILESDIR}"/${PN}-4.2-jserver.patch

	#Substitute for internal downloading. pciutils copied only due to the only .bz2
	cp "${DISTDIR}"/pciutils-2.2.9.tar.bz2 ./stubdom/ || die "pciutils not copied to stubdom"
	retar-externals || die "re-tar procedure failed"

	epatch_user
}

src_configure() {
	local myconf="--prefix=${PREFIX}/usr \
		--libdir=${PREFIX}/usr/$(get_libdir) \
		--libexecdir=${PREFIX}/usr/libexec \
		--disable-werror \
		--disable-xen"

	econf ${myconf}
}

src_compile() {
	use custom-cflags || unset CFLAGS
	if test-flag-CC -fno-strict-overflow; then
		append-flags -fno-strict-overflow
	fi

	emake CC="$(tc-getCC)" LD="$(tc-getLD)" AR="$(tc-getAR)" -C tools/include

	if use x86; then
		emake CC="$(tc-getCC)" LD="$(tc-getLD)" AR="$(tc-getAR)" \
		XEN_TARGET_ARCH="x86_32" -C stubdom pv-grub
	elif use amd64; then
		emake CC="$(tc-getCC)" LD="$(tc-getLD)" AR="$(tc-getAR)" \
		XEN_TARGET_ARCH="x86_64" -C stubdom pv-grub
		if has_multilib_profile; then
			multilib_toolchain_setup x86
			emake CC="$(tc-getCC)" AR="$(tc-getAR)" \
			XEN_TARGET_ARCH="x86_32" -C stubdom pv-grub
		fi
	fi
}

src_install() {
	if use x86; then
		emake XEN_TARGET_ARCH="x86_32" DESTDIR="${D}" -C stubdom install-grub
	fi
	if use amd64; then
		emake XEN_TARGET_ARCH="x86_64" DESTDIR="${D}" -C stubdom install-grub
		if has_multilib_profile; then
			emake XEN_TARGET_ARCH="x86_32" DESTDIR="${D}" -C stubdom install-grub
		fi
	fi
}

pkg_postinst() {
	elog "Official Xen Guide and the offical wiki page:"
	elog "https://wiki.gentoo.org/wiki/Xen"
	elog "http://wiki.xen.org/wiki/Main_Page"
}
