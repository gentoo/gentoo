# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools pam pax-utils systemd user xdg-utils

DESCRIPTION="Policy framework for controlling privileges for system-wide services"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/polkit"
SRC_URI="https://www.freedesktop.org/software/${PN}/releases/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ~mips ppc ppc64 s390 ~sh x86"
IUSE="consolekit elogind examples gtk +introspection jit kde nls pam selinux systemd test"
RESTRICT="!test? ( test )"

REQUIRED_USE="^^ ( consolekit elogind systemd )"

CDEPEND="
	dev-lang/spidermonkey:52[-debug]
	dev-libs/glib:2
	dev-libs/expat
	elogind? ( sys-auth/elogind )
	introspection? ( dev-libs/gobject-introspection )
	pam? (
		sys-auth/pambase
		sys-libs/pam
	)
	systemd? ( sys-apps/systemd:0=[policykit] )
"
DEPEND="${CDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/docbook-xsl-stylesheets
	dev-libs/gobject-introspection-common
	dev-libs/libxslt
	dev-util/glib-utils
	dev-util/gtk-doc-am
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-policykit )
"
PDEPEND="
	consolekit? ( sys-auth/consolekit[policykit] )
	gtk? ( || (
		>=gnome-extra/polkit-gnome-0.105
		>=lxde-base/lxsession-0.5.2
	) )
	kde? ( kde-plasma/polkit-kde-agent )
"

DOCS=( docs/TODO HACKING NEWS README )

PATCHES=(
	# bug 660880
	"${FILESDIR}"/polkit-0.115-elogind.patch
	"${FILESDIR}"/CVE-2018-19788.patch
)

QA_MULTILIB_PATHS="
	usr/lib/polkit-1/polkit-agent-helper-1
	usr/lib/polkit-1/polkitd"

pkg_setup() {
	local u=polkitd
	local g=polkitd
	local h=/var/lib/polkit-1

	enewgroup ${g}
	enewuser ${u} -1 -1 ${h} ${g}
	esethome ${u} ${h}
}

src_prepare() {
	default

	sed -i -e 's|unix-group:wheel|unix-user:0|' src/polkitbackend/*-default.rules || die #401513

	# Workaround upstream hack around standard gtk-doc behavior, bug #552170
	sed -i -e 's/@ENABLE_GTK_DOC_TRUE@\(TARGET_DIR\)/\1/' \
		-e '/install-data-local:/,/uninstall-local:/ s/@ENABLE_GTK_DOC_TRUE@//' \
		-e 's/@ENABLE_GTK_DOC_FALSE@install-data-local://' \
		docs/polkit/Makefile.in || die

	# disable broken test - bug #624022
	sed -i -e "/^SUBDIRS/s/polkitbackend//" test/Makefile.am || die

	# Fix cross-building, bug #590764, elogind patch, bug #598615
	eautoreconf
}

src_configure() {
	xdg_environment_reset

	local myeconfargs=(
		--localstatedir="${EPREFIX}"/var
		--disable-static
		--enable-man-pages
		--disable-gtk-doc
		--disable-examples
		$(use_enable elogind libelogind)
		$(use_enable introspection)
		$(use_enable nls)
		$(usex pam "--with-pam-module-dir=$(getpam_mod_dir)" '')
		--with-authfw=$(usex pam pam shadow)
		$(use_enable systemd libsystemd-login)
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		$(use_enable test)
		--with-os-type=gentoo
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	default

	# Required for polkitd on hardened/PaX due to spidermonkey's JIT
	pax-mark mr src/polkitbackend/.libs/polkitd test/polkitbackend/.libs/polkitbackendjsauthoritytest
}

src_install() {
	default

	fowners -R polkitd:root /{etc,usr/share}/polkit-1/rules.d

	diropts -m0700 -o polkitd -g polkitd
	keepdir /var/lib/polkit-1

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins src/examples/{*.c,*.policy*}
	fi

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	chown -R polkitd:root "${EROOT}"/{etc,usr/share}/polkit-1/rules.d
	chown -R polkitd:polkitd "${EROOT}"/var/lib/polkit-1
}
