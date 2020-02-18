# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

MY_P=${PN}-$(ver_rs 1- "")

DESCRIPTION="A portable viewer of binary files, hexadecimal and disassembler modes"
HOMEPAGE="http://beye.sourceforge.net/"
SRC_URI="mirror://sourceforge/beye/${PV}/${MY_P}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gpm cpu_flags_x86_mmx cpu_flags_x86_sse"
REQUIRED_USE="cpu_flags_x86_mmx cpu_flags_x86_sse"

RDEPEND="gpm? ( sys-libs/gpm )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-610-fix_localedep-1.patch
	"${FILESDIR}"/${PN}-610-portable_configure-1.patch
	"${FILESDIR}"/${PN}-610-crash.patch
)

src_prepare() {
	default
	sed -i -e 's^man/man1/biew.1^share/man/man1/biew.1^' makefile || die
}

src_configure() {
	append-flags -mmmx -msse #362043
	append-cppflags $(usex gpm -DHAVE_MOUSE -UHAVE_MOUSE)

	./configure \
		--datadir="${EPREFIX}"/usr/share/${PN} \
		--prefix="${EPREFIX}"/usr \
		--cc="$(tc-getCC)" \
		--ld="$(tc-getCC)" \
		--ar="$(tc-getAR) -rcu" \
		--as="$(tc-getAS)" \
		--ranlib="$(tc-getRANLIB)" || die "configure failed"
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}"
}

src_install() {
	default
	dodoc doc/{biew_en,release,unix}.txt
}

pkg_postinst() {
	elog
	elog "Note: if you are upgrading from <=dev-util/biew-6.1.0 you will need"
	elog "to change the paths in the setup dialog (F9) from /usr/share/ to"
	elog "/usr/share/biew/ Alternatively, you can delete ~/.biewrc and it will"
	elog "automatically determine the correct locations on the next run."
	elog
}
