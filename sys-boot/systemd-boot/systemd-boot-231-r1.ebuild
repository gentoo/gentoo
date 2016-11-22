# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils toolchain-funcs

DESCRIPTION="UEFI boot manager from systemd (formerly gummiboot)"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/systemd/systemd-boot/"
SRC_URI="https://github.com/systemd/systemd/archive/v${PV}.tar.gz -> systemd-${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 MIT public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="
	>=sys-apps/util-linux-2.27.1:0=
	sys-libs/libcap:=
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt:0
	>=dev-util/intltool-0.50
	>=sys-boot/gnu-efi-3.0.2
"
RDEPEND="${COMMON_DEPEND}
	!sys-apps/systemd
"

S="${WORKDIR}/systemd-${PV}"

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

efi-mt() {
	case "$(tc-arch)" in
		amd64) echo x64 ;;
		arm64) echo aa64 ;;
		x86) echo ia32 ;;
		*) die "Unsupported arch" ;;
	esac
}

src_compile() {
	local args=(
		libsystemd-shared.la
		bootctl
		man/bootctl.1
		man/kernel-install.8
		linux$(efi-mt).efi.stub
		systemd-boot$(efi-mt).efi
	)
	emake built-sources
	emake "${args[@]}"
}

src_install() {
	local args=(
		DESTDIR="${D%/}"

		# libsystemd-shared
		rootlibexec_LTLIBRARIES=libsystemd-shared.la
		install-rootlibexecLTLIBRARIES

		# bootctl
		lib_LTLIBRARIES=
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
	prune_libtool_files
	einstalldocs
}
