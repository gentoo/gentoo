# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit autotools gnome2-utils python-single-r1 systemd user

DESCRIPTION="Automatic bug detection and reporting tool"
HOMEPAGE="https://github.com/abrt/abrt/wiki/ABRT-Project"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug selinux"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.56:2
	>=dev-libs/libreport-2.10.0[python]
	dev-libs/libxml2:2
	>=gnome-base/gsettings-desktop-schemas-3.15.1
	net-libs/libsoup:2.4
	sys-apps/dbus
	sys-apps/systemd:0=
	sys-auth/polkit
	sys-fs/inotify-tools
	x11-libs/gtk+:3
"
RDEPEND="${COMMON_DEPEND}
	app-arch/cpio
	app-arch/rpm
	dev-libs/elfutils
	dev-libs/json-c:0=
	dev-python/argcomplete[${PYTHON_USEDEP}]
	dev-python/argh[${PYTHON_USEDEP}]
	dev-python/humanize[${PYTHON_USEDEP}]
	sys-apps/util-linux
	>=sys-devel/gdb-7
"
DEPEND="${COMMON_DEPEND}
	app-text/asciidoc
	app-text/xmlto
	dev-libs/satyr[${PYTHON_USEDEP}]
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
	>=sys-devel/gettext-0.17
"

RESTRICT="test" # tests *may* be broken due to all the RHEL crap.  explore later.

pkg_setup() {
	python-single-r1_pkg_setup

	enewgroup abrt
	enewuser abrt -1 -1 -1 abrt
}

src_prepare() {
	default

	# Install under proper directory
	sed -i -e 's:dbusabrtdocdir = ${datadir}/doc/abrt-dbus-${VERSION}/html:dbusabrtdocdir = ${datadir}/doc/${PF}/html:' doc/problems-service/Makefile.am || die

	# Ensure this works for systems with and without /usr merge
	sed -i -e "s:/usr/bin/bash:$(which bash):" init-scripts/abrtd.service || die

	# pyhook test is sensitive to the format of python's error messages, and
	# fails with certain python versions
	sed -e '/pyhook.at/ d' \
		-i tests/Makefile.* tests/testsuite.at || die "sed remove pyhook tests failed"
	./gen-version || die # Needed to be run before autoreconf
	eautoreconf
}

src_configure() {
	myeconfargs=(
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--localstatedir="${EPREFIX}/var"
		--without-bodhi
		# package breaks due to not finding libreport-web with bodhi plugin enabled
		--without-rpm
		$(usex selinux "" "--without-selinux")
		--without-python2
		# Fixes "syntax error in VERSION script" and we aren't supporting Python2 anyway
		--with-python3
		--without-pythondoc
		# package breaks due to no sphinx-build-3
		--without-pythontests
		# kill tests for now until they can be explored.
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	python_optimize #661706

	keepdir /var/run/abrt
	# /var/spool/abrt is created by dev-libs/libreport

	diropts -m 700 -o abrt -g abrt
	keepdir /var/spool/abrt-upload

	diropts -m 775 -o abrt -g abrt
	keepdir /var/cache/abrt-di

	find "${D}" -name '*.la' -delete || die

	newinitd "${FILESDIR}/${PN}-2.0.12-r1-init" abrt
	newconfd "${FILESDIR}/${PN}-2.0.12-r1-conf" abrt
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
