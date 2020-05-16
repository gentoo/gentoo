# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="An easy to use text editor"
#HOMEPAGE="http://mahon.cwx.net/ http://www.users.uswest.net/~hmahon/"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux"
IUSE="X"

RDEPEND="X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-ae-location.patch
	"${FILESDIR}"/${PN}-Wformat-security.patch
	"${FILESDIR}"/${PN}-gcc-10.patch
)
DOCS=( Changes README.${PN} ${PN}.i18n.guide ${PN}.msg )

src_prepare() {
	sed -i \
		-e "s/make -/\$(MAKE) -/g" \
		-e "/^buildaee/s/$/ localaee/" \
		-e "/^buildxae/s/$/ localxae/" \
		Makefile

	sed -i \
		-e "s/\([\t ]\)cc /\1\\\\\$(CC) /" \
		-e "/CFLAGS =/s/\" >/ \\\\\$(LDFLAGS)\" >/" \
		-e "/other_cflag/s/ \${strip_option}//" \
		-e "s/-lcurses/$($(tc-getPKG_CONFIG) --libs ncurses)/" \
		create.mk.{aee,xae}

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
