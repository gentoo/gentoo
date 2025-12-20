# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit prefix toolchain-funcs

DESCRIPTION="An easy to use text editor"
HOMEPAGE="https://gitlab.com/ports1/aee"
SRC_URI="https://gitlab.com/ports1/aee/-/archive/${PV}/${P}.tar.bz2"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"
IUSE="X"

RDEPEND="X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-ae-location.patch
	"${FILESDIR}"/${PN}-gcc-10.patch
)
DOCS=( Changes README.${PN} ${PN}.i18n.guide ${PN}.msg )

src_prepare() {
	sed -i \
		-e "s/make -/\$(MAKE) -/g" \
		-e "/^buildaee/s/$/ localaee/" \
		-e "/^buildxae/s/$/ localxae/" \
		Makefile || die

	sed -i \
		-e "s/\([\t ]\)cc /\1\\\\\$(CC) /" \
		-e "/CFLAGS =/s/\" >/ \\\\\$(LDFLAGS)\" >/" \
		-e "/other_cflag/s/ \${strip_option}//" \
		-e "s/-lcurses/$($(tc-getPKG_CONFIG) --libs ncurses)/" \
		create.mk.{aee,xae} || die

	hprefixify create.mk.{aee,xae}

	# https://gitlab.com/ports1/aee/-/merge_requests/1
	chmod +x create.mk.{aee,xae} || die

	default
}

src_compile() {
	local target="aee"
	use X && target="both"

	emake CC="$(tc-getCC)" ${target}
}

src_install() {
	dobin ${PN}
	dosym ${PN} /usr/bin/rae
	doman ${PN}.1
	einstalldocs

	insinto /usr/share/${PN}
	doins help.ae

	if use X; then
		dobin xae
		dosym xae /usr/bin/rxae
	fi
}
