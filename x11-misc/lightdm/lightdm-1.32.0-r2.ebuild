# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools pam qmake-utils readme.gentoo-r1 systemd vala xdg-utils

DESCRIPTION="A lightweight display manager"
HOMEPAGE="https://github.com/canonical/lightdm"
SRC_URI="https://github.com/canonical/lightdm/releases/download/${PV}/${P}.tar.xz
	mirror://gentoo/introspection-20110205.m4.tar.bz2"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="audit elogind +gnome +gtk +introspection non-root qt5 systemd vala"

REQUIRED_USE="^^ ( elogind systemd )
	vala? ( introspection )"

RESTRICT="test"

COMMON_DEPEND="
	>=dev-libs/glib-2.44.0:2
	dev-libs/libgcrypt:=
	dev-libs/libxml2
	sys-libs/pam
	x11-libs/libX11
	>=x11-libs/libxklavier-5
	audit? ( sys-process/audit )
	gnome? ( sys-apps/accountsservice )
	introspection? ( >=dev-libs/gobject-introspection-1 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
	)
"
RDEPEND="${COMMON_DEPEND}
	acct-group/lightdm
	acct-group/video
	acct-user/lightdm
	>=sys-auth/pambase-20101024-r2
	elogind? ( sys-auth/elogind[pam] )
	systemd? ( sys-apps/systemd[pam] )"
DEPEND="${COMMON_DEPEND}
	gnome? ( gnome-base/gnome-common )
"
BDEPEND="
	dev-util/gtk-doc-am
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"
PDEPEND="gtk? ( x11-misc/lightdm-gtk-greeter )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.30.0-musl-locale.patch
	"${FILESDIR}"/${PN}-1.30.0-musl-updwtmpx.patch
)

DOCS=( NEWS )

pkg_setup() {
	export LIGHTDM_USER=${LIGHTDM_USER:-lightdm}
	vala_setup
}

src_prepare() {
	xdg_environment_reset

	sed -i -e 's:getgroups:lightdm_&:' tests/src/libsystem.c || die #412369
	sed -i -e '/minimum-uid/s:500:1000:' data/users.conf || die

	einfo "Fixing the session-wrapper variable in lightdm.conf"
	sed -i -e \
		"/^#session-wrapper/s@^.*@session-wrapper=/etc/${PN}/Xsession@" \
		data/lightdm.conf || die "Failed to fix lightdm.conf"

	# use correct version of qmake. bug #566950
	sed \
		-e "/AC_CHECK_TOOLS(MOC5/a AC_SUBST(MOC5,$(qt5_get_bindir)/moc)" \
		-i configure.ac || die

	default

	# Remove bogus Makefile statement. This needs to go upstream
	sed -i /"@YELP_HELP_RULES@"/d help/Makefile.am || die
	if has_version dev-libs/gobject-introspection; then
		eautoreconf
	else
		AT_M4DIR=${WORKDIR} eautoreconf
	fi
}

src_configure() {
	# Set default values if global vars unset
	local _greeter _session _user
	_greeter=${LIGHTDM_GREETER:=lightdm-gtk-greeter}
	_session=${LIGHTDM_SESSION:=gnome}
	_user="$(usex non-root "${LIGHTDM_USER}" root)"
	# Let user know how lightdm is configured
	einfo "Gentoo configuration"
	einfo "Default greeter: ${_greeter}"
	einfo "Default session: ${_session}"
	einfo "Greeter user: ${_user}"

	# also disable tests because libsystem.c does not build. Tests are
	# restricted so it does not matter anyway.
	local myeconfargs=(
		--localstatedir=/var
		--disable-static
		--disable-tests
		$(use_enable audit libaudit)
		$(use_enable introspection)
		$(use_enable qt5 liblightdm-qt5)
		$(use_enable vala)
		--with-user-session=${_session}
		--with-greeter-session=${_greeter}
		--with-greeter-user=${_user}
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# Delete apparmor profiles because they only work with Ubuntu's
	# apparmor package. Bug #494426
	if [[ -d ${ED}/etc/apparmor.d ]]; then
		rm -r "${ED}/etc/apparmor.d" || die \
			"Failed to remove apparmor profiles"
	fi

	insinto /etc/${PN}
	doins data/{${PN},keys}.conf
	newins "${FILESDIR}"/Xsession-r1 Xsession
	fperms +x /etc/${PN}/Xsession
	# /var/lib/lightdm-data could be useful. Bug #522228
	keepdir /var/lib/${PN}-data

	find "${ED}" -type f \( -name '*.a' -o -name "*.la" \) -delete || die
	rm -r "${ED}"/etc/init || die

	# Remove existing pam file. We will build a new one. Bug #524792
	rm -r "${ED}"/etc/pam.d/${PN}{,-greeter} || die
	pamd_mimic system-local-login ${PN} auth account password session #372229
	pamd_mimic system-local-login ${PN}-greeter auth account password session #372229
	dopamd "${FILESDIR}"/${PN}-autologin #390863, #423163

	readme.gentoo_create_doc

	systemd_newunit "${FILESDIR}"/${PN}.service-r1 ${PN}.service
}

pkg_postinst() {
	systemd_reenable "${PN}.service"

	# Bug #886607
	ewarn
	ewarn "If you have a Nvidia GPU and ${PN} fails to launch X, edit /etc/${PN}/${PN}.conf to include the line"
	ewarn
	ewarn "logind-check-graphical=false"
	ewarn
	ewarn "in the section [LightDM]. See https://github.com/canonical/lightdm/issues/263 for details."
}
