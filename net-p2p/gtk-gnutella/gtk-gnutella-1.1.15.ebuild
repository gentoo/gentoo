# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# eutils: strip-linguas
inherit eutils toolchain-funcs

IUSE="nls dbus ssl +gtk"

DESCRIPTION="A GTK+ Gnutella client"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"
HOMEPAGE="http://gtk-gnutella.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ~ppc64 x86"

RDEPEND="
	sys-libs/binutils-libs:=
	dev-libs/glib:2
	sys-libs/zlib
	gtk? ( >=x11-libs/gtk+-2.2.1:2 )
	dbus? ( >=sys-apps/dbus-0.35.2 )
	ssl? ( >=net-libs/gnutls-2.2.5 )
	nls? ( >=sys-devel/gettext-0.11.5 )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	strip-linguas -i po

	echo "# Gentoo-selected LINGUAS" > po/LINGUAS
	for ling in ${LINGUAS}; do
		echo $ling >> po/LINGUAS
	done

	default
}

src_configure() {
	# There is no option to turn off optimization through the build.sh
	# script.
	sed -i -e "s/Configure -Oder/Configure -Oder -Doptimize=none/" build.sh || die

	# The build script does not support the equivalent --enable
	# options so we must construct the configuration by hand.

	local myconf

	if ! use nls; then
		myconf="${myconf} --disable-nls"
	fi

	if ! use dbus; then
		myconf="${myconf} --disable-dbus"
	fi

	if ! use ssl; then
		myconf="${myconf} --disable-gnutls"
	fi

	if use gtk; then
		myconf="${myconf} --gtk2"
	else
		myconf="${myconf} --topless"
	fi

	./build.sh \
		--configure-only \
		--prefix="/usr" \
		--cc=$(tc-getCC) \
		${myconf}
}

src_compile() {
	# Build system is not parallel-safe, bug 500760
	emake -j1
}

src_install() {
	dodir /usr/bin
	emake INSTALL_PREFIX="${D}" install
	dodoc AUTHORS ChangeLog README TODO

	# Touch the symbols file into the future to avoid warnings from
	# gtk-gnutella later on, since we will most likely strip the binary.
	touch --date="next minute" "${D}/usr/lib/gtk-gnutella/gtk-gnutella.nm" || die
}
