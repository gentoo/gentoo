# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info linux-mod toolchain-funcs

DESCRIPTION="Kernel modules for GPIB (IEEE 488.2) hardware"
HOMEPAGE="https://linux-gpib.sourceforge.io/"
SRC_URI="mirror://sourceforge/linux-gpib/linux-gpib-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
IUSE="debug"

COMMONDEPEND=""
RDEPEND="${COMMONDEPEND}
	acct-group/gpib
	!<sci-libs/linux-gpib-4.2.0_rc1
"
DEPEND="${COMMONDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/linux-gpib-kernel-${PV}

PATCHES=(
	"${FILESDIR}/${PN}-4.3.0-kernel53.patch"
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
		DESTDIR="${D}" \
		INSTALL_MOD_PATH="${D}" \
		docdir=/usr/share/doc/${PF}/html \
		${my_gpib_makeopts}
}

src_install() {
	set_arch_to_kernel
	emake \
		DESTDIR="${D}" \
		INSTALL_MOD_PATH="${D}" \
		DEPMOD="/bin/true" \
		docdir=/usr/share/doc/${PF}/html \
		${my_gpib_makeopts} \
		install

	dodoc ChangeLog AUTHORS README* NEWS
}
