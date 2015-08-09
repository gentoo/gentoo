# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit bsdmk flag-o-matic

DESCRIPTION="Virtio drivers from FreeBSD Ports' emulators/virtio-kmod"
HOMEPAGE="http://www.freshports.org/emulators/virtio-kmod/"
SRC_URI="mirror://freebsd/ports/local-distfiles/kuriyama/virtio-${PV}.tar.gz"

SLOT="0"
KEYWORDS="~x86-fbsd ~amd64-fbsd"
IUSE="custom-cflags +debug"
LICENSE="BSD-2"

DEPEND=">=sys-freebsd/freebsd-sources-8.2
	app-arch/cpio"
RDEPEND=""

QA_TEXTRELS="*"
RESTRICT="strip"
S="${WORKDIR}"

NEEDSUBDIRS="conf contrib dev/pci geom kern net netinet netinet6 sys tools vm
	x86 i386 amd64"

src_unpack() {
	default
	CPIO_ARGS="-dump"

	# When hardlinks are possible, use them to avoid copies when FEATURES=userpriv
	test $UID != 0 && export CPIO_ARGS+=l

	cd /usr/src/sys/
	for d in $NEEDSUBDIRS; do
		find $d ! -name @ | cpio --quiet "${CPIO_ARGS}" "${WORKDIR}"
	done

}

src_compile() {

	use debug && export DEBUG_FLAGS="-g"
	use custom-cflags || strip-flags
	append-cflags "-I${WORKDIR}"

	cd "${WORKDIR}/modules/virtio"
	mkmake SYSDIR="${WORKDIR}" LDFLAGS="$(raw-ldflags)" || die "mkmake failed"

}

src_install() {
	# Upstream does not provide an install target
	dodir /boot/modules
	cp "${WORKDIR}"/modules/virtio/*/*.ko{,.symbols} "${ED}/boot/modules"
}

pkg_postinst() {
	# Update linker.hints file
	/usr/sbin/kldxref "${EPREFIX}/boot/modules"

	# Print message from FreeBSD Ports
	elog "$(cat "${FILESDIR}/pkg-message")"
}

pkg_postrm() {
	# Update linker.hints file
	/usr/sbin/kldxref "${EPREFIX}/boot/modules"
}
