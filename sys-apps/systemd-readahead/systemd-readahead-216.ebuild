# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit systemd toolchain-funcs udev

DESCRIPTION="Split of readahead systemd implementation"
HOMEPAGE="https://dev.gentoo.org/~pacho/systemd-readahead.html"
SRC_URI="https://www.freedesktop.org/software/systemd/systemd-${PV}.tar.xz"
S="${WORKDIR}/systemd-${PV}"

LICENSE="LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"

RDEPEND=">=sys-apps/systemd-217:="
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils:0
	dev-util/gperf
	>=dev-util/intltool-0.50
	>=sys-apps/coreutils-8.16
	>=sys-devel/binutils-2.23.1
	>=sys-kernel/linux-headers-3.8
	virtual/pkgconfig
"

PATCHES=(
	# https://github.com/systemd/systemd/pull/2838 , bug #604614
	"${FILESDIR}/${P}-sysmacros.patch"

	# https://github.com/systemd/systemd/issues/8099, bug #650314
	"${FILESDIR}"/${P}-glibc-2.27.patch
)

src_prepare() {
	default

	# systemd-notify no longer supports readahead playing
	sed -i -e 's:ExecStart=@SYSTEMD_NOTIFY@ --readahead=done:ExecStart=/bin/touch /run/systemd/readahead/done:' \
		units/systemd-readahead-done.service.in || die
}

src_configure() {
	# Keep using the one where the rules were installed.
	MY_UDEVDIR=$(get_udevdir)
	# Fix systems broken by bug #509454.
	[[ ${MY_UDEVDIR} ]] || MY_UDEVDIR=/lib/udev

	local myeconfargs=(
		# disable -flto since it is an optimization flag
		# and makes distcc less effective
		cc_cv_CFLAGS__flto=no

		--enable-readahead

		--disable-maintainer-mode
		--localstatedir=/var
		# make sure we get /bin:/sbin in $PATH
		--enable-split-usr
		# For testing.
		--with-rootprefix="${ROOTPREFIX-/usr}"
		--with-rootlibdir="${ROOTPREFIX-/usr}/$(get_libdir)"
		# disable sysv compatibility
		--with-sysvinit-path=
		--with-sysvrcnd-path=
		# Disable most of the stuff
		--disable-efi
		--disable-ima
		--disable-acl
		--disable-apparmor
		--disable-audit
		--disable-libcryptsetup
		--disable-libcurl
		--disable-gtk-doc
		--disable-elfutils
		--disable-gcrypt
		--disable-gudev
		--disable-microhttpd
		--disable-gnutls
		--disable-libidn
		--disable-introspection
		--disable-kdbus
		--disable-kmod
		--disable-lz4
		--disable-xz
		--disable-pam
		--disable-polkit
		--without-python
		--disable-python-devel
		--disable-qrencode
		--disable-seccomp
		--disable-selinux
		--disable-tests
		--disable-dbus

		--disable-smack
		--disable-blkid
		--disable-multi-seat-x
		--disable-myhostname

		# Disable optional binaries
		--disable-backlight
		--disable-binfmt
		--disable-bootchart
		--disable-coredump
		--disable-firstboot
		--disable-hostnamed
		--disable-localed
		--disable-logind
		--disable-machined
		--disable-networkd
		--disable-quotacheck
		--disable-randomseed
		--disable-resolved
		--disable-rfkill
		--disable-sysusers
		--disable-timedated
		--disable-timesyncd
		--disable-tmpfiles
		--disable-vconsole

		# not supported (avoid automagic deps in the future)
		--disable-chkconfig

		# dbus paths
		--with-dbuspolicydir="${EPREFIX}/etc/dbus-1/system.d"
		--with-dbussessionservicedir="${EPREFIX}/usr/share/dbus-1/services"
		--with-dbussystemservicedir="${EPREFIX}/usr/share/dbus-1/system-services"
		--with-dbusinterfacedir="${EPREFIX}/usr/share/dbus-1/interfaces"
	)

	# Work around bug 463846.
	tc-export CC

	econf "${myeconfargs[@]}"
}

src_compile() {
	echo 'BUILT_SOURCES: $(BUILT_SOURCES)' > ./Makefile.extra
	emake -f Makefile -f ./Makefile.extra BUILT_SOURCES

	# Fix compilation, bug #607068
	# From comments at https://aur.archlinux.org/packages/systemd-readahead
	gperf < src/libsystemd/sd-bus/bus-error-mapping.gperf > src/libsystemd/sd-bus/bus-error-mapping.c || die
	sed -i -e "/bus_error_mapping_lookup/s/size_t/unsigned int/" src/libsystemd/sd-bus/bus-error-mapping.c || die
	sed -i -e "/lookup_errno/s/size_t/unsigned int/" src/shared/errno-from-name.h || die
	sed -i -e "/lookup_af/s/size_t/unsigned int/" src/shared/af-from-name.h || die
	sed -i -e "/lookup_arphrd/s/size_t/unsigned int/" src/shared/arphrd-from-name.h || die

	emake systemd-readahead
	emake units/systemd-readahead-{drop,collect,replay,done}.service units/systemd-readahead-done.timer
	emake man/{sd-readahead.3,sd_readahead.3,systemd-readahead-replay.service.8}
}

src_test() {
	einfo "No specific tests for this"
}

src_install() {
	# Install main app
	exeinto /usr/lib/systemd/
	doexe systemd-readahead

	# Install unit files
	systemd_dounit units/systemd-readahead-{drop,collect,replay,done}.service units/systemd-readahead-done.timer

	# Install manpages and aliases
	doman man/{sd-readahead.3,sd_readahead.3,systemd-readahead-replay.service.8}
	newman man/systemd-readahead-replay.service.8 systemd-readahead-collect.service.8
	newman man/systemd-readahead-replay.service.8 systemd-readahead-done.service.8
	newman man/systemd-readahead-replay.service.8 systemd-readahead-done.timer.8
	newman man/systemd-readahead-replay.service.8 systemd-readahead.8

	# Install docs
	dodoc TODO README
}
