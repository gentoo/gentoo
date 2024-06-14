# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

DESCRIPTION="Kernel modules for GPIB (IEEE 488.2) hardware"
HOMEPAGE="https://linux-gpib.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/linux-gpib/linux-gpib-${PV}.tar.gz"
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
	# don't fix debian bugs if they break gentoo
	"${FILESDIR}/${PN}-4.3.4-depmod.patch"
)

MODULES_KERNEL_MIN=2.6.8

src_unpack() {
	default
	unpack "${WORKDIR}/linux-gpib-${PV}/linux-gpib-kernel-${PV}.tar.gz"
}

src_configure() {
	MODULES_MAKEARGS+=( LINUX_SRCDIR="${KV_OUT_DIR}" )
	use debug && MODULES_MAKEARGS+=( 'GPIB-DEBUG=1' )
}

src_compile() {
	# The individual modules don't have separate targets so we can't use
	# modlist here.
	emake "${MODULES_MAKEARGS[@]}"
}

src_install() {
	emake \
		"${MODULES_MAKEARGS[@]}" \
		DESTDIR="${ED}" \
		INSTALL_MOD_PATH="${ED}" \
		docdir="${ED}/usr/share/doc/${PF}/html" \
		install

	modules_post_process

	dodoc ChangeLog AUTHORS README* NEWS
	einstalldocs
}
