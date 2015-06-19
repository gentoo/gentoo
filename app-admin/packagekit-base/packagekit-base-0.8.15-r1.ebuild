# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/packagekit-base/packagekit-base-0.8.15-r1.ebuild,v 1.2 2014/07/24 17:42:36 ssuominen Exp $

EAPI="5"

# PackageKit supports 3.2+, but entropy and portage backends are untested
# Future note: use --enable-python3
PYTHON_COMPAT=( python2_7 )

inherit eutils autotools multilib python-single-r1 nsplugins bash-completion-r1

MY_PN="PackageKit"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Manage packages in a secure way using a cross-distro and cross-architecture API"
HOMEPAGE="http://www.packagekit.org/"
SRC_URI="http://www.packagekit.org/releases/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
IUSE="bash-completion connman cron command-not-found doc +introspection networkmanager nsplugin entropy static-libs systemd"

CDEPEND="bash-completion? ( >=app-shells/bash-completion-2.0 )
	connman? ( net-misc/connman )
	introspection? ( >=dev-libs/gobject-introspection-0.9.9[${PYTHON_USEDEP}] )
	networkmanager? ( >=net-misc/networkmanager-0.6.4 )
	nsplugin? (
		>=dev-libs/nspr-4.8
		x11-libs/cairo
		>=x11-libs/gtk+-2.14.0:2
		x11-libs/pango
	)
	dev-db/sqlite:3
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.32.0:2[${PYTHON_USEDEP}]
	>=sys-auth/polkit-0.98
	>=sys-apps/dbus-1.3.0
	${PYTHON_DEPS}"
DEPEND="${CDEPEND}
	doc? ( dev-util/gtk-doc[${PYTHON_USEDEP}] )
	nsplugin? ( >=net-misc/npapi-sdk-0.27 )
	systemd? ( >=sys-apps/systemd-204 )
	dev-libs/libxslt[${PYTHON_USEDEP}]
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
	sys-devel/gettext"

RDEPEND="${CDEPEND}
	entropy? ( >=sys-apps/entropy-234[${PYTHON_USEDEP}] )
	>=app-portage/layman-1.2.3[${PYTHON_USEDEP}]
	>=sys-apps/portage-2.2[${PYTHON_USEDEP}]"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

APP_LINGUAS="as bg bn ca cs da de el en_GB es fi fr gu he hi hu it ja kn ko ml mr
ms nb nl or pa pl pt pt_BR ro ru sk sr sr@latin sv ta te th tr uk zh_CN zh_TW"
for X in ${APP_LINGUAS}; do
	IUSE=" ${IUSE} linguas_${X}"
done

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.8.x-npapi-sdk.patch #383141

	# Upstreamed patches
	epatch "${FILESDIR}/0001-entropy-PackageKitEntropyClient.output-API-update.patch"
	epatch "${FILESDIR}/${P}-qtdbus-annotate.patch"

	epatch_user

	# npapi-sdk patch and epatch_user
	eautoreconf
}

src_configure() {
	econf \
		$(test -n "${LINGUAS}" && echo -n "--enable-nls" || echo -n "--disable-nls") \
		--enable-introspection=$(use introspection && echo -n "yes" || echo -n "no") \
		--localstatedir=/var \
		$(use_enable bash-completion) \
		--disable-dependency-tracking \
		--enable-option-checking \
		--enable-libtool-lock \
		--disable-local \
		--with-default-backend=$(use entropy && echo -n "entropy" || echo -n "portage") \
		$(use_enable doc gtk-doc) \
		$(use_enable command-not-found) \
		--disable-debuginfo-install \
		--disable-gstreamer-plugin \
		--enable-man-pages \
		--enable-portage \
		$(use_enable entropy) \
		$(use_enable cron) \
		--disable-gtk-module \
		$(use_enable introspection) \
		$(use_enable networkmanager) \
		$(use_enable nsplugin browser-plugin) \
		$(use_enable static-libs static) \
		$(use_enable systemd) \
		$(use_enable systemd systemd-updates) \
		$(use_enable connman)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS MAINTAINERS NEWS README TODO || die "dodoc failed"
	dodoc ChangeLog || die "dodoc failed"

	if use nsplugin; then
		dodir "/usr/$(get_libdir)/${PLUGINS_DIR}"
		mv "${D}/usr/$(get_libdir)/mozilla/plugins"/* \
			"${D}/usr/$(get_libdir)/${PLUGINS_DIR}/" || die
	fi

	if ! use static-libs; then
		prune_libtool_files --all
	fi
}
