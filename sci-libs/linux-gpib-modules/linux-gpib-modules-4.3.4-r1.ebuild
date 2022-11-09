# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info linux-mod

DESCRIPTION="Kernel modules for GPIB (IEEE 488.2) hardware"
HOMEPAGE="https://linux-gpib.sourceforge.io/"
SRC_URI="mirror://sourceforge/linux-gpib/linux-gpib-${PV}.tar.gz"
S="${WORKDIR}/linux-gpib-kernel-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
IUSE="debug"

COMMONDEPEND=""
RDEPEND="${COMMONDEPEND}
	acct-group/gpib
"
DEPEND="${COMMONDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# https://sourceforge.net/p/linux-gpib/code/1998/
	"${FILESDIR}/${P}-kernel-5.17.patch"

	# don't fix debian bugs if they break gentoo
	"${FILESDIR}/${P}-depmod.patch"
)

pkg_setup() {
	linux-mod_pkg_setup

	if kernel_is -lt 2 6 8; then
		die "Kernel versions older than 2.6.8 are not supported."
	fi
}

src_unpack() {
	default
	unpack "${WORKDIR}/linux-gpib-${PV}/linux-gpib-kernel-${PV}.tar.gz"
}

src_configure() {
	set_arch_to_kernel

	my_gpib_makeopts=''
	use debug && my_gpib_makeopts+='GPIB-DEBUG=1 '

	my_gpib_makeopts+="LINUX_SRCDIR=${KERNEL_DIR} "
}

src_compile() {
	set_arch_to_kernel
	emake \
		${my_gpib_makeopts}
}

src_install() {
	set_arch_to_kernel
	emake \
		DESTDIR="${ED}" \
		INSTALL_MOD_PATH="${ED}" \
		DEPMOD="/bin/true" \
		docdir="${ED}/usr/share/doc/${PF}/html" \
		${my_gpib_makeopts} \
		install

	dodoc ChangeLog AUTHORS README* NEWS
}
