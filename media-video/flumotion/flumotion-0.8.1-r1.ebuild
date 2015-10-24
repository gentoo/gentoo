# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit eutils fdo-mime flag-o-matic multilib python-single-r1 toolchain-funcs user virtualx # AC_CHECK_PROG for Xvfb

DESCRIPTION="Flumotion Streaming server"
HOMEPAGE="http://www.flumotion.net/"
SRC_URI="http://www.flumotion.net/src/${PN}/${P}.tar.bz2"

LICENSE="GPL-2" # LICENSE.Flumotion
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# TODO:

# These would be from 0.6.2's ebuild
# media-plugins/gst-plugins-libpng:0.10
# dev-python/twisted-web
# dev-python/twisted-names
# dev-python/imaging

# These are from README
RDEPEND="${PYTHON_DEPS}
	dev-python/gst-python:0.10[${PYTHON_USEDEP}]
	dev-python/kiwi[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	dev-python/twisted-core[${PYTHON_USEDEP}]
	media-libs/gstreamer:0.10
	media-libs/gst-plugins-base:0.10
	media-libs/gst-plugins-good:0.10
	media-plugins/gst-plugins-ogg:0.10
	media-plugins/gst-plugins-theora:0.10
	media-plugins/gst-plugins-vorbis:0.10
"
# These are from README and error and trial FEATURES="test" Import's
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( dev-python/epydoc[${PYTHON_USEDEP}] )
	test? ( dev-python/icalendar[${PYTHON_USEDEP}]
		dev-python/pychecker[${PYTHON_USEDEP}]
		dev-python/twisted-conch[${PYTHON_USEDEP}] )"

src_prepare() {
	# Fix .desktop file
	sed -e 's/.png//' -i data/flumotion-admin.desktop.in || die

	# Fix shebangs
	sed -e '1 s:.*:#!/usr/bin/env python:' \
		-i bin/flu*.in bin/runtest.in misc/flu*.in || die
	python_fix_shebang bin/flu*.in bin/runtest.in misc/flu*.in
}

src_configure() {
	append-cflags -fno-strict-aliasing

	econf \
		--localstatedir=/var \
		$(use_enable doc docs)
}

src_compile() {
	emake -j1 fdpass_so_LINK="$(tc-getCC) ${LDFLAGS} -shared -o fdpass.so"
}

src_test() {
	# FIXME: restrict unittests to flumotion source folder
	# other tests are failing in weird ways and does not seem to test much of flumotion
	Xemake -j1 check -C flumotion
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	einstalldocs
	dodoc RELEASE

	keepdir /var/log/flumotion

	newinitd "${FILESDIR}"/flumotion-init-3 flumotion

	# /usr/share/hal/fdi/policy/20thirdparty/91-flumotion-device-policy.fdi
	rm -rf "${D}"/usr/share/hal || die

	dodir /etc/flumotion
	dodir /etc/flumotion/managers
	dodir /etc/flumotion/managers/default
	dodir /etc/flumotion/managers/default/flows
	dodir /etc/flumotion/workers

	pushd conf
	insinto /etc/flumotion/managers/default
	doins managers/default/planet.xml
	insinto /etc/flumotion/workers
	doins workers/default.xml
	insinto /etc/flumotion
	doins default.pem
	popd
}

pkg_postinst() {
	fdo-mime_desktop_database_update

	if ! enewgroup flumotion || ! enewuser flumotion -1 -1 /usr/share/flumotion flumotion,audio,video,sys; then
		die "Unable to add flumotion user and flumotion group."
	fi

	for dir in /usr/share/flumotion /var/log/flumotion ; do
		chown -R flumotion:flumotion "${dir}"
		chmod -R 755 "${dir}"
	done
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
