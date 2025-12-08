# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature toolchain-funcs

DOLILO_V="0.6"

DESCRIPTION="LInux LOader, the original Linux bootloader"
HOMEPAGE="https://www.joonet.de/lilo/"

DOLILO_TAR="dolilo-${DOLILO_V}.tar.bz2"
SRC_URI="
	https://www.joonet.de/lilo/ftp/sources/${P}.tar.gz
	mirror://gentoo/${DOLILO_TAR}
"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"

IUSE="device-mapper keytab pxeserial static"

DEPEND="sys-devel/bin86"
RDEPEND="
	device-mapper? ( sys-fs/lvm2 )
	keytab? ( dev-lang/perl )
"

PATCHES=(
	"${FILESDIR}"/${PN}-24.2-Makefile-tweaks.patch
	"${FILESDIR}"/${PN}-24.2-add-nvme-support.patch
	"${FILESDIR}"/${PN}-24.x-fix-gcc-10.patch
	"${FILESDIR}"/${PN}-24.x-check-for-__GLIBC__.patch
	"${FILESDIR}"/${PN}-24.2-fix-gcc-15.patch
	"${FILESDIR}"/${PN}-24.2-musl.patch
	"${FILESDIR}"/${PN}-24.2-remove-gcc-ver-check.patch
)

# Bootloaders should not be using arbitrary CFLAGS without good reason.  A bootloader
# is typically only executed once to boot the system, and it should work the first time.
QA_FLAGS_IGNORED="sbin/lilo"

src_prepare() {
	default

	# this patch is needed when booting PXE and the device you're using
	# emulates vga console via serial console.
	# IE..  B.B.o.o.o.o.t.t.i.i.n.n.g.g....l.l.i.i.n.n.u.u.x.x and stair stepping.
	use pxeserial && eapply "${FILESDIR}/${PN}-24.1-novga.patch"
}

src_configure() {
	if ! use device-mapper; then
		sed -i make.vars -e 's|-DDEVMAPPER||g' || die
	fi
}

src_compile() {
	# lilo needs this. bug #140209
	export LC_ALL=C

	local target=$(usex static alles all)

	# we explicitly prevent the custom CFLAGS for stability reasons
	emake CC="$(tc-getCC) ${LDFLAGS}" ${target}
}

src_install() {
	emake DESTDIR="${ED}" install

	into /
	dosbin "${WORKDIR}"/dolilo/dolilo

	if use keytab; then
		into /usr
		dosbin keytab-lilo.pl
	fi

	insinto /etc
	newins "${FILESDIR}"/lilo.conf lilo.conf.example

	newconfd "${WORKDIR}"/dolilo/dolilo.conf.d dolilo.example

	dodoc CHANGELOG* readme/README.* readme/INCOMPAT README
	docinto samples ; dodoc sample/*

	# This we don't use
	rm -r "${ED}/etc/initramfs" || die
	# This should be in /usr/lib and it should have the .install suffix
	dodir /usr/lib/kernel
	for dir in postinst.d postrm.d; do
		mv "${ED}/etc/kernel/${dir}" "${ED}/usr/lib/kernel/${dir}" || die
		mv "${ED}/usr/lib/kernel/${dir}/zz-runlilo" "${ED}/usr/lib/kernel/${dir}/90-runlilo.install" || die
	done
	# Insert wrapper for systemd's kernel-install
	exeinto /usr/lib/kernel/install.d
	newexe - 90-runlilo.install <<-EOF
		#!/bin/sh
		if [ "\${1}" = "add" ]; then
			exec "\$(dirname \${0})/../postinst.d/90-runlilo.install"
		elif [ "\${1}" = "remove" ]; then
			exec "\$(dirname \${0})/../postrm.d/90-runlilo.install"
		fi
	EOF
}

pkg_postinst() {
	if [[ ! -e "${ROOT}/boot/boot.b" && ! -L "${ROOT}/boot/boot.b" ]]; then
		[[ -f "${ROOT}/boot/boot-menu.b" ]] && \
			ln -snf boot-menu.b "${ROOT}/boot/boot.b"
	fi

	einfo
	einfo "Issue 'dolilo' instead of 'lilo' to have a friendly wrapper that"
	einfo "handles mounting and unmounting /boot for you. It can do more, "
	einfo "edit /etc/conf.d/dolilo to harness its full potential."
	einfo

	optfeature "automatically updating lilo's configuration on each kernel installation" \
		sys-kernel/installkernel
}
