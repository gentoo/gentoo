# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Using strip-linguas in eutils
inherit eutils autotools systemd

DESCRIPTION="LXDE Display Manager"
HOMEPAGE="https://wiki.lxde.org/en/LXDM"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"

IUSE="consolekit debug gtk3 nls pam"

RDEPEND="consolekit? ( sys-auth/consolekit )
	x11-libs/libxcb
	gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( x11-libs/gtk+:2 )
	nls? ( sys-devel/gettext )
	pam? ( sys-libs/pam )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig"
DOCS=( AUTHORS README TODO )

src_prepare() {
	# Upstream bug, tarball contains pre-made lxdm.conf
	rm "${S}"/data/lxdm.conf || die

	# Fix consolekit and selinux
	eapply "${FILESDIR}/${P}-pam_console-disable.patch"
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
		$(use_enable consolekit) \
		$(use_enable gtk3) \
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
