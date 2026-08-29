# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs xdg

DESCRIPTION="Tool for creating error correction data (ecc) for optical media (DVD, CD, BD)"
HOMEPAGE="https://github.com/speed47/dvdisaster"
SRC_URI="https://github.com/speed47/${PN}/archive/refs/tags/v${PV/_p/-pl}.tar.gz -> ${P}.tar.gz"

MY_P="${PN}-${PV/_p/-pl}"

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug nls"

dvdi_langs="cs de it pt-BR ru sv"
for dvdi_lang in ${dvdi_langs}; do
	IUSE+=" l10n_${dvdi_lang}"
done
unset dvdi_lang

RDEPEND="
	dev-libs/glib:2
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="
	nls? ( sys-devel/gettext )
	virtual/os-headers
	virtual/pkgconfig"

DOCS=( CHANGELOG COPYING CREDITS.en CREDITS.de README TODO )

src_prepare() {
	default
	sed -i -e "s@CC=gcc@CC=$(tc-getCC)@" scripts/bash-based-configure || die
}

src_configure() {
	./configure \
		--prefix="${EPREFIX}"/usr \
		--bindir="${EPREFIX}"/usr/bin \
		--mandir="${EPREFIX}"/usr/share/man \
		--docdir="${EPREFIX}"/usr/share/doc \
		--docsubdir=${PF} \
		--localedir="${EPREFIX}"/usr/share/locale \
		--buildroot="${D}" \
		--with-memdebug=$(usex debug) \
		--with-nls=$(usex nls) || die
}

src_compile() {
	emake $(use nls && echo -j1) CC="$(tc-getCC)"
}

src_install() {
	default

	newicon contrib/${PN}48.png ${PN}.png
	make_desktop_entry ${PN} ${PN} ${PN} 'System;Utility'

	local res
	for res in 16 32 48 64; do
		newicon -s ${res} contrib/${PN}${res}.png ${PN}.png
	done

	local dest="${ED}"/usr/share

	local dvdi_lang
	for dvdi_lang in ${dvdi_langs}; do
		use l10n_${dvdi_lang} || rm -rf \
			${dest}/doc/${PF}/${dvdi_lang/-/_} \
			${dest}/doc/${PF}/CREDITS.${dvdi_lang/-/_} \
			${dest}/man/${dvdi_lang/-/_} || die
	done

	rm "${ED}"/usr/bin/*-uninstall.sh || die
}
