# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools pam qmake-utils readme.gentoo-r1 systemd vala xdg-utils

DESCRIPTION="A lightweight display manager"
HOMEPAGE="https://github.com/CanonicalLtd/lightdm"
SRC_URI="https://github.com/CanonicalLtd/lightdm/releases/download/${PV}/${P}.tar.xz
	mirror://gentoo/introspection-20110205.m4.tar.bz2"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ppc ppc64 ~riscv x86"
IUSE="audit +gnome +gtk +introspection non-root qt5 vala"

COMMON_DEPEND="
	>=dev-libs/glib-2.44.0:2
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
	>=sys-auth/pambase-20101024-r2"
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

DOCS=( NEWS )
RESTRICT="test"
REQUIRED_USE="vala? ( introspection )"

pkg_setup() {
	export LIGHTDM_USER=${LIGHTDM_USER:-lightdm}
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

	use vala && vala_src_prepare
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
		--disable-liblightdm-qt
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
	doins "${FILESDIR}"/Xsession
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

	systemd_dounit "${FILESDIR}/${PN}.service"
}

pkg_postinst() {
	systemd_reenable "${PN}.service"
}
