# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools strip-linguas systemd

DESCRIPTION="LXDE Display Manager"
HOMEPAGE="https://wiki.lxde.org/en/LXDM"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ppc ~ppc64 ~riscv x86"

IUSE="debug elogind nls pam systemd"

# Although cairo, gdk-pixbuf, and pango are not directly checked and often forced by gtk+
# They are directly referenced in the C code of the greeter and config util
DEPEND="
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/pango
	x11-libs/libX11
	x11-libs/libxcb:0=
	virtual/libcrypt:0=
	pam? ( sys-libs/pam )"
# We only use the pam modules and not actually link to the code
RDEPEND="${DEPEND}
	elogind? ( sys-auth/elogind[pam] )
	systemd? ( sys-apps/systemd[pam] )
"
BDEPEND="
	app-text/iso-codes
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
DOCS=( AUTHORS README TODO )

REQUIRED_USE="?? ( elogind systemd ) elogind? ( pam ) systemd? ( pam )"

src_prepare() {
	# Upstream bug, tarball contains pre-made lxdm.conf
	rm "${S}"/data/lxdm.conf || die

	# Fix consolekit and selinux
	eapply "${FILESDIR}/${P}-pam.patch"
	# Apply all upstream fixes in git until 2016-11-11
	eapply "${FILESDIR}/lxdm-0.5.3-upstream-fixes.patch"
	eapply_user

	# this replaces the bootstrap/autogen script in most packages
	eautoreconf

	# process LINGUAS
	if use nls; then
		einfo "Running intltoolize ..."
		intltoolize --force --copy --automake || die
		strip-linguas -i "${S}/po" || die
	fi
}
src_configure() {
	econf	--enable-password \
		--with-x \
		--with-xconn=xcb \
		--with-systemdsystemunitdir=$(systemd_get_systemunitdir) \
		--disable-consolekit \
		--enable-gtk3 \
		$(use_enable nls) \
		$(use_enable debug) \
		$(use_with pam)
}

src_install() {
	default_src_install

	#Use Gentoo specific Xsession startup file
	exeinto /etc/${PN}
	doexe "${FILESDIR}"/Xsession
}
