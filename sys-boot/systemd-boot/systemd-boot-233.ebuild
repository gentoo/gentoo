# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs

DESCRIPTION="UEFI boot manager from systemd (formerly gummiboot)"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/systemd/systemd-boot/"
SRC_URI="https://github.com/systemd/systemd/archive/v${PV}.tar.gz -> systemd-${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 MIT public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="test"

COMMON_DEPEND="
	>=sys-apps/util-linux-2.27.1
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt:0
	>=dev-util/intltool-0.50
	dev-util/gperf
	>=sys-boot/gnu-efi-3.0.2
	sys-libs/libcap
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	!sys-apps/systemd
"

S="${WORKDIR}/systemd-${PV}"

PATCHES=(
	"${FILESDIR}"/233-Force-libsystemd-shared-to-be-static.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		EFI_CC="$(tc-getPROG "EFI_CC CC" gcc)"
		cc_cv_CFLAGS__flto=no
		cc_cv_LDFLAGS__Wl__fuse_ld_gold=no
		--enable-blkid
		--enable-efi
		--enable-gnuefi
		--disable-acl
		--disable-apparmor
		--disable-audit
		--disable-bzip2
		--disable-elfutils
		--disable-gcrypt
		--disable-gnutls
		--disable-kmod
		--disable-libcryptsetup
		--disable-libcurl
		--disable-libidn
		--disable-lz4
		--disable-microhttpd
		--disable-myhostname
		--disable-pam
		--disable-qrencode
		--disable-seccomp
		--disable-selinux
		--disable-xkbcommon
		--disable-xz
		--disable-zlib
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	local targets=(
		bootctl
		man/bootctl.1
		man/kernel-install.8
		'$(bootlib_DATA)'
	)
	emake built-sources
	echo "gentoo: ${targets[*]}" | emake -f Makefile -f - gentoo
}

src_install() {
	local args=(
		DESTDIR="${D%/}"

		# bootctl
		bin_PROGRAMS=bootctl
		install-binPROGRAMS

		# kernel-install
		install-dist_binSCRIPTS
		install-dist_kernelinstallSCRIPTS

		man_MANS="man/bootctl.1 man/kernel-install.8"
		install-man1
		install-man8

		install-bootlibDATA
	)
	emake "${args[@]}"
	einstalldocs
}
