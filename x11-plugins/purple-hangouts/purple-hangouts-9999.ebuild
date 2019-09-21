# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs mercurial

DESCRIPTION="Hangouts Plugin for libpurple"
HOMEPAGE="https://bitbucket.org/EionRobb/purple-hangouts"
EHG_REPO_URI="https://bitbucket.org/EionRobb/purple-hangouts"

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/protobuf-c:=
	net-im/pidgin
	sys-libs/zlib"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-0_p20181202-makefile.patch" )

src_prepare() {
	default

	# Does not respect CFLAGS
	sed -i Makefile -e 's/-g -ggdb//g' || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
}

src_install() {
	emake \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		DESTDIR="${ED}" \
		install

	einstalldocs
}
