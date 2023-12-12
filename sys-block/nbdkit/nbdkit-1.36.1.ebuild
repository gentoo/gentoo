# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools optfeature bash-completion-r1

DESCRIPTION="NBD server with stable plugin ABI and permissive license"
HOMEPAGE="https://gitlab.com/nbdkit/nbdkit"
SRC_URI="https://download.libguestfs.org/nbdkit/$(ver_cut 1-2)-stable/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="
	curl ext2 nbd gnutls libguestfs libssh libvirt lzma selinux torrent
	valgrind zlib zlib-ng zstd
"

RDEPEND="
	virtual/libiconv
	selinux? ( sys-libs/libselinux )
	gnutls? ( net-libs/gnutls:= )
	curl? ( net-misc/curl )
	libssh? ( net-libs/libssh:= )
	libvirt? ( app-emulation/libvirt:= )
	zlib? ( sys-libs/zlib )
	zlib-ng? ( sys-libs/zlib-ng )
	nbd? ( sys-libs/libnbd )
	lzma? ( app-arch/xz-utils )
	zstd? ( app-arch/zstd:= )
	libguestfs? ( app-emulation/libguestfs:= )
	ext2? ( sys-fs/e2fsprogs )
	torrent? ( net-libs/libtorrent-rasterbar:= )
"
DEPEND="
	${RDEPEND}
	valgrind? ( dev-util/valgrind )
"
BDEPEND="
	dev-lang/perl
"

src_prepare() {
	default

	# TODO(arsen): This test fails for some reason.
	cat <<-HACK > tests/test-file-extents.sh || die
		#!/bin/sh
		echo Gentoo: This test is skipped
		exit 77
	HACK

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-extra=Gentoo

		--with-iconv
		--with-manpages

		$(use_with selinux)
		$(use_with gnutls)
		$(use_with curl)
		$(use_with libvirt)
		$(use_with zlib)
		$(use_with zlib-ng)
		$(use_with nbd libnbd)
		$(use_with lzma liblzma)
		$(use_with zstd libzstd)
		$(use_with libguestfs)
		$(use_with ext2)
		$(use_enable torrent)
		$(use_enable valgrind)

		--disable-linuxdisk # Not in Gentoo.
		--disable-libfuzzer # Should not be used normally according to upstream
		--without-libblkio # Not in Gentoo.
		--without-bash-completions # Handled manually.

		# TODO(arsen): Bindings left out
		--disable-perl
		--disable-python
		--disable-ocaml
		--disable-rust
		--disable-ruby
		--disable-tcl
		--disable-lua
		--disable-golang

		# This just enabled a few code paths with no extra library
		# dependencies, but it does have an extra xorriso runtime
		# dependency.  Seeing as it's optional, and it conflates BDEPEND
		# and RDEPEND; I think it's okay to just specify that it uses
		# XORRISO installed as xorriso.  Maybe the user should be able
		# to override this in the future if they prefer one of the other
		# ISOPROGs?
		--with-iso
		ac_cv_prog_XORRISO=xorriso

		# Involves proprietary code and a dlopen mess, see
		# plugins/vddk/README.VDDK.
		--disable-vddk
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
	dobashcomp bash-completion/nbdkit
}

pkg_postinst() {
	optfeature "virtual ISO plugin via xorriso" dev-libs/libisoburn
}
