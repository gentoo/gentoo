# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info linux-mod autotools toolchain-funcs

DESCRIPTION="Kernel modules for GPIB (IEEE 488.2) hardware"
HOMEPAGE="https://linux-gpib.sourceforge.io/"
SRC_URI="mirror://sourceforge/linux-gpib/linux-gpib-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
IUSE="isa pcmcia debug"

COMMONDEPEND=""
RDEPEND="${COMMONDEPEND}
	!<sci-libs/linux-gpib-4.2.0_rc1
"
DEPEND="${COMMONDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-4.2.0_rc1-reallydie.patch
)

S=${WORKDIR}/linux-gpib-kernel-${PV}

pkg_setup () {
	linux-mod_pkg_setup

	if kernel_is -lt 2 6 8; then
		die "Kernel versions older than 2.6.8 are not supported."
	fi

	# https://sourceforge.net/p/linux-gpib/bugs/43/
	if use pcmcia && kernel_is -ge 2 6 38; then
		die "pcmcia support is broken on kernels newer 2.6.38"
	fi
}

src_unpack() {
	default
	unpack "${WORKDIR}/linux-gpib-${PV}/linux-gpib-kernel-${PV}.tar.gz"
}

src_prepare () {
	default
	eautoreconf
}

src_configure() {
	set_arch_to_kernel
	econf \
		$(use_enable isa) \
		$(use_enable pcmcia) \
		$(use_enable debug driver-debug) \
		--with-linux-srcdir=${KV_DIR}
}

src_compile() {
	set_arch_to_kernel
	emake \
		DESTDIR="${D}" \
		INSTALL_MOD_PATH="${D}" \
		docdir=/usr/share/doc/${PF}/html
}

src_install() {
	set_arch_to_kernel
	emake \
		DESTDIR="${D}" \
		INSTALL_MOD_PATH="${D}" \
		DEPMOD="/bin/true" \
		docdir=/usr/share/doc/${PF}/html install

	dodoc ChangeLog AUTHORS README* NEWS
}

pkg_preinst () {
	linux-mod_pkg_preinst
	enewgroup gpib
}

pkg_postinst () {
	linux-mod_pkg_postinst
}
