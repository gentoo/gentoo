# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Red-blue Quake II! Play quake2 with 3D glasses!"
HOMEPAGE="https://www.jfedor.org/red-blue-quake2/"
SRC_URI="mirror://idsoftware/source/q2source-3.21.zip
	https://www.jfedor.org/red-blue-quake2/${P}.tar.gz"
S="${WORKDIR}"/quake2-3.21

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${PV}-gentoo.patch
	"${FILESDIR}"/${P}-gcc41.patch
	"${FILESDIR}"/${P}-ldflags.patch
)

src_prepare() {
	default

	cd linux || die

	sed -i \
		-e "s:GENTOO_DIR:$(get_libdir)/${PN}:" \
		sys_linux.c || die

	sed -i \
		-e "s:/etc/quake2.conf:/etc/${PN}.conf:" \
		sys_linux.c vid_so.c || die

	sed -i \
		-e 's:-O6::' \
		-e 's:-g::' \
		Makefile || die

	echo "$(get_libdir)"/${PN} > "${T}"/${PN}.conf || die
}

src_compile() {
	cd linux || die

	mkdir -p releasei386-glibc/ref_soft || die

	emake \
		CC="$(tc-getCC)" \
		GENTOO_CFLAGS="${CFLAGS}" \
		GENTOO_DATADIR=/usr/share/quake2/baseq2/ \
		build_release
}

src_install() {
	cd linux/release* || die

	exeinto "$(get_libdir)"/${PN}
	doexe gamei386.so ref_softx.so

	exeinto "$(get_libdir)"/${PN}/ctf
	doexe ctf/gamei386.so
	newbin quake2 red-blue-quake2

	insinto /etc
	doins "${T}"/${PN}.conf
}
