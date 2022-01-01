# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE="xml"
inherit python-single-r1 systemd xdg

DESCRIPTION="Graphical user interface for CUPS administration"
HOMEPAGE="https://github.com/OpenPrinting/system-config-printer"
SRC_URI="https://github.com/OpenPrinting/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="gnome-keyring policykit"
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
	dev-perl/XML-Parser
	dev-util/desktop-file-utils
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_MULTI_USEDEP}]
		dev-python/pycairo[${PYTHON_MULTI_USEDEP}]
		dev-python/pycups[${PYTHON_MULTI_USEDEP}]
		dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
		dev-python/requests[${PYTHON_MULTI_USEDEP}]
		dev-python/urllib3[${PYTHON_MULTI_USEDEP}]
	')
	gnome-keyring? ( app-crypt/libsecret[introspection] )
	policykit? ( net-print/cups-pk-helper )
"

PATCHES=(
	"${FILESDIR}"/${P}-check-for-null.patch
	"${FILESDIR}"/${P}-fix-abrt-in-udev-configure-printer.patch
	"${FILESDIR}"/${P}-catch-urllib-errors.patch
	"${FILESDIR}"/${P}-fix-remember-passwd.patch
	"${FILESDIR}"/${P}-py39-{1,2}.patch
)

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	local myeconfargs=(
		--enable-nls
		--with-desktop-vendor=Gentoo
		--with-udev-rules
		--with-systemdsystemunitdir=$(systemd_get_systemunitdir)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	python_fix_shebang "${ED}"
	python_optimize
}
