# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/system-config-printer-common/system-config-printer-common-1.4.3.ebuild,v 1.9 2014/08/21 10:38:17 ago Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit autotools eutils python-single-r1 systemd

MY_P=${PN%-common}-${PV}

DESCRIPTION="Common modules of Red Hat's printer administration tool"
HOMEPAGE="http://cyberelk.net/tim/software/system-config-printer/"
SRC_URI="http://cyberelk.net/tim/data/${PN/-common}/${PV%.*}/${MY_P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 ~sh ~sparc x86"
SLOT="0"
IUSE="doc policykit"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Needs cups running, bug 284005
RESTRICT="test"

# system-config-printer split since 1.1.3
#
# Additional unhandled dependencies:
# net-firewall/firewalld[${PYTHON_USEDEP}]
# gnome-extra/gnome-packagekit[${PYTHON_USEDEP}] with pygobject:2 ?
COMMON_DEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2
	dev-libs/libxml2[python,${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	>=dev-python/pycups-1.9.60[${PYTHON_USEDEP}]
	dev-python/pycurl[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	net-print/cups[dbus]
	virtual/libusb:1
	>=virtual/udev-172
"
DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils
	dev-util/intltool
	virtual/pkgconfig
	doc? ( dev-python/epydoc[${PYTHON_USEDEP}] )
"
RDEPEND="${COMMON_DEPEND}
	!<app-admin/system-config-printer-gnome-${PV}
	policykit? ( >=sys-auth/polkit-0.104-r1 )
"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.4.1-split.patch
	eautoreconf
}

src_configure() {
	econf \
		--disable-nls \
		--with-udev-rules \
		$(systemd_with_unitdir)
}

src_compile() {
	emake
	use doc && emake html
}

src_install() {
	default

	use doc && dohtml -r html/

	python_fix_shebang "${ED}"
}
