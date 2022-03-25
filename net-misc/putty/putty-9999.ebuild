# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools desktop git-r3 toolchain-funcs xdg-utils

DESCRIPTION="A Free Telnet/SSH Client"
HOMEPAGE="https://www.chiark.greenend.org.uk/~sgtatham/putty/"
EGIT_REPO_URI="https://git.tartarus.org/simon/putty.git"
SRC_URI="https://dev.gentoo.org/~polynomial-c/${PN}-icons.tar.bz2"
LICENSE="MIT"

SLOT="0"
KEYWORDS=""
IUSE="doc +gtk gtk2 ipv6 gssapi"

RDEPEND="
	!net-misc/pssh
	gtk? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf
		x11-libs/libX11
		x11-libs/pango
		gtk2? ( x11-libs/gtk+:2 )
		!gtk2? ( x11-libs/gtk+:3[X] )
	)
	gssapi? ( virtual/krb5 )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	app-doc/halibut
	dev-lang/perl
	virtual/pkgconfig
"
REQUIRED_USE="
	gtk2? ( gtk )
"

src_unpack() {
	git-r3_src_unpack
	default
}

src_prepare() {
	default

	sed -i \
		-e 's|-Werror||g' \
		configure.ac || die

	./mkfiles.pl || die

	eautoreconf
}

src_configure() {
	cd "${S}"/unix || die
	econf \
		$(use_with gssapi) \
		$(usex gtk --with-gtk= --without-gtk $(usex gtk2 2 3 ) )
}

src_compile() {
	emake -C "${S}"/doc
	emake -C "${S}"/unix AR="$(tc-getAR)" $(usex ipv6 '' COMPAT=-DNO_IPV6)
}

src_test() {
	emake -C unix cgtest
	unix/cgtest || die
}

src_install() {
	dodoc doc/puttydoc.txt

	if use doc; then
		docinto html
		dodoc doc/*.html
	fi

	cd "${S}"/unix || die
	default

	if use gtk ; then
		for i in 16 22 24 32 48 64 128 256; do
			newicon -s ${i} "${WORKDIR}"/${PN}-icons/${PN}-${i}.png ${PN}.png
		done

		# install desktop file provided by Gustav Schaffter in #49577
		make_desktop_entry ${PN} PuTTY ${PN} Network
	fi
}

pkg_postinst() {
	use gtk && xdg_icon_cache_update
}

pkg_postrm() {
	use gtk && xdg_icon_cache_update
}
