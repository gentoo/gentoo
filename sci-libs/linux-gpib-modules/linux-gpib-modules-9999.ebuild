# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.code.sf.net/p/linux-gpib/git"
	S="${WORKDIR}/${P}/linux-gpib-kernel"
else
	SRC_URI="https://downloads.sourceforge.net/linux-gpib/linux-gpib-${PV}.tar.gz"
	S="${WORKDIR}/linux-gpib-kernel-${PV}"
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="Kernel modules for GPIB (IEEE 488.2) hardware"
HOMEPAGE="https://linux-gpib.sourceforge.io/"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug"

RDEPEND="
	acct-group/gpib
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# don't fix debian bugs if they break gentoo
	"${FILESDIR}/${PN}-9999-depmod.patch"
)

MODULES_KERNEL_MIN=2.6.8

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	else
		default
		unpack "${WORKDIR}/linux-gpib-${PV}/linux-gpib-kernel-${PV}.tar.gz"
	fi
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

	dodoc AUTHORS README* NEWS
	[[ ${PV} != 9999 ]] && dodoc ChangeLog
	einstalldocs
}
