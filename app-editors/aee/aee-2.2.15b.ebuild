# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils toolchain-funcs

DESCRIPTION="An easy to use text editor"
HOMEPAGE="http://mahon.cwx.net/"
SRC_URI="http://mahon.cwx.net/sources/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux"
IUSE="X"

RDEPEND="X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-*.diff

	sed -i \
		-e "s/make -/\$(MAKE) -/g" \
		-e "/^buildaee/s/$/ localaee/" \
		-e "/^buildxae/s/$/ localxae/" \
		Makefile || die

	sed -i \
		-e "s/\([\t ]\)cc /\1\\\\\$(CC) /" \
		-e "/CFLAGS =/s/\" >/ \\\\\$(LDFLAGS)\" >/" \
		-e "/other_cflag/s/ \${strip_option}//" \
		create.mk.{aee,xae} || die

	tc-export CC
}

src_compile() {
	local target="aee"
	use X && target="both"

	emake ${target}
}

src_install() {
	dobin ${PN}
	dosym ${PN} /usr/bin/rae
	doman ${PN}.1
	dodoc Changes README.${PN} ${PN}.i18n.guide ${PN}.msg

	insinto /usr/share/${PN}
	doins help.ae

	if use X; then
		dobin xae
		dosym xae /usr/bin/rxae
	fi
}
