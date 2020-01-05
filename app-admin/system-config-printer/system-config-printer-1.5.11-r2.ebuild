# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )
PYTHON_REQ_USE="xml"
inherit gnome2 python-single-r1 systemd

DESCRIPTION="Graphical user interface for CUPS administration"
HOMEPAGE="https://github.com/zdohnal/system-config-printer"
SRC_URI="https://github.com/zdohnal/${PN}/releases/download/${PV}/${P}.tar.xz
	https://dev.gentoo.org/~asturm/distfiles/${P}-patchset-01.tar.xz"

LICENSE="GPL-2+"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ppc ppc64 ~sh ~sparc x86"
SLOT="0"

IUSE="doc gnome-keyring policykit"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Needs cups running, bug 284005
RESTRICT="test"

# Additional unhandled dependencies
# gnome-extra/gnome-packagekit[${PYTHON_USEDEP}] with pygobject:2 ?
# python samba client: smbc
# selinux: needed for troubleshooting
COMMON_DEPEND="${PYTHON_DEPS}
	dev-libs/glib:2
	net-print/cups[dbus]
	virtual/libusb:1
	>=virtual/udev-172
	x11-libs/gtk+:3[introspection]
	x11-libs/libnotify[introspection]
	x11-libs/pango[introspection]
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	>=app-text/xmlto-0.0.22
	dev-util/desktop-file-utils
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( dev-python/epydoc )
"
RDEPEND="${COMMON_DEPEND}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pycups[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
	gnome-keyring? ( app-crypt/libsecret[introspection] )
	policykit? ( net-print/cups-pk-helper )
"

PATCHES=(
	"${WORKDIR}"/${P}-auth-dialog.patch
	"${WORKDIR}"/${P}-libsecret-optional-{1,2}.patch
	"${WORKDIR}"/${P}-scp-dbus-service-{1,2}.patch
	"${WORKDIR}"/${P}-typo.patch
	"${WORKDIR}"/${P}-appdata.patch
	"${WORKDIR}"/${P}-empty-LC_MESSAGES.patch
	"${WORKDIR}"/${P}-fdopen-utf8.patch
	"${WORKDIR}"/${P}-typeerror.patch
	"${WORKDIR}"/${P}-debugprint-typo.patch
)

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	gnome2_src_configure \
		--enable-nls \
		--with-desktop-vendor=Gentoo \
		--with-udev-rules \
		--with-systemdsystemunitdir=$(systemd_get_systemunitdir)
}

src_compile() {
	gnome2_src_compile
	use doc && emake html
}

src_install() {
	use doc && local HTML_DOCS=( html/. )
	gnome2_src_install
	python_fix_shebang "${ED}"
}
