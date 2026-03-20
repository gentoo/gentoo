# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs systemd

DESCRIPTION="IP multicast routing daemon"
HOMEPAGE="https://troglobit.com/projects/mrouted/"
SRC_URI="https://github.com/troglobit/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="Stanford GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test"
# Needs unshare
RESTRICT="!test? ( test ) test"

BDEPEND="
	app-alternatives/yacc
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/mrouted-4.6-c23-compat.patch" #944046
)

src_configure() {
	tc-export CC CXX

	# rename mtrace binary to mrtrace to avoid conflict with glibc (886145)
	# and rewrite the man page so we don't confuse people
	sed -i -e 's/MTRACE/MRTRACE/' -e 's/mtrace/mrtrace/' man/mtrace.8 || die
	econf $(use_enable test) "--program-transform-name='s/^mtrace/mrtrace/'"
}

src_compile() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)"
}

src_install() {
	default

	insinto /etc
	doins mrouted.conf

	newinitd "${FILESDIR}"/mrouted.rc mrouted
	systemd_dounit mrouted.service
}

pkg_postinst() {
	ewarn "The mtrace program from mrouted conflicts with the one installed by glibc"
	ewarn "so it has been renamed to mrtrace. See mrtrace(8) for documentation."
}
