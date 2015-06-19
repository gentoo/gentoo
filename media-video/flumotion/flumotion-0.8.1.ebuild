# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/flumotion/flumotion-0.8.1.ebuild,v 1.7 2014/01/08 06:04:33 vapier Exp $

EAPI=3

PYTHON_DEPEND="2:2.6"

inherit eutils user flag-o-matic multilib python toolchain-funcs virtualx # AC_CHECK_PROG for Xvfb

DESCRIPTION="Flumotion Streaming server"
HOMEPAGE="http://www.flumotion.net/"
SRC_URI="http://www.flumotion.net/src/${PN}/${P}.tar.bz2"

LICENSE="GPL-2" # LICENSE.Flumotion
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

# TODO:

# These would be from 0.6.2's ebuild
# media-plugins/gst-plugins-libpng:0.10
# dev-python/twisted-web
# dev-python/twisted-names
# dev-python/imaging

# These are from README
RDEPEND="dev-python/gst-python:0.10
	dev-python/kiwi
	dev-python/pycairo
	=dev-python/pygtk-2*
	dev-python/twisted-core
	media-libs/gstreamer:0.10
	media-libs/gst-plugins-base:0.10
	media-libs/gst-plugins-good:0.10
	media-plugins/gst-plugins-ogg:0.10
	media-plugins/gst-plugins-theora:0.10
	media-plugins/gst-plugins-vorbis:0.10"
# These are from README and error and trial FEATURES="test" Import's
DEPEND="${RDEPEND}
	sys-devel/gettext
	doc? ( dev-python/epydoc )
	test? ( dev-python/icalendar
		dev-python/pychecker
		dev-python/twisted-conch )"

src_prepare() {
	rm -f py-compile
	ln -s $(type -P true) py-compile
}

src_configure() {
	append-cflags -fno-strict-aliasing

	econf \
		--localstatedir=/var \
		$(use_enable doc docs)
}

src_compile() {
	emake -j1 fdpass_so_LINK="$(tc-getCC) ${LDFLAGS} -shared -o fdpass.so" || die
}

src_test() {
	Xemake -j1 check || die
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README RELEASE TODO

	keepdir /var/log/flumotion
	keepdir /var/run/flumotion

	newinitd "${FILESDIR}"/flumotion-init-0.2.0 flumotion

	# /usr/share/hal/fdi/policy/20thirdparty/91-flumotion-device-policy.fdi
	rm -rf "${D}"/usr/share/hal

	dodir /etc/flumotion
	dodir /etc/flumotion/managers
	dodir /etc/flumotion/managers/default
	dodir /etc/flumotion/managers/default/flows
	dodir /etc/flumotion/workers

	pushd conf
	insinto /etc/flumotion/managers/default
	doins managers/default/planet.xml || die
	insinto /etc/flumotion/workers
	doins workers/default.xml || die
	insinto /etc/flumotion
	doins default.pem || die
	popd
}

pkg_postinst() {
	if ! enewgroup flumotion || ! enewuser flumotion -1 -1 /usr/share/flumotion flumotion,audio,video,sys; then
		die "Unable to add flumotion user and flumotion group."
	fi

	for dir in /usr/share/flumotion /var/log/flumotion /var/run/flumotion; do
		chown -R flumotion:flumotion "${dir}"
		chmod -R 755 "${dir}"
	done

	python_mod_optimize /usr/$(get_libdir)/flumotion/python
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/flumotion/python
}
