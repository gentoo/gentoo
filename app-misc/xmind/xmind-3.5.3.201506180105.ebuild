# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib gnome2-utils

MY_PN="${PN}-portable"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A brainstorming and mind mapping software tool"
HOMEPAGE="http://www.xmind.net"
SRC_URI="http://dl2.xmind.net/xmind-downloads/${MY_P}.zip
	http://dev.gentoo.org/~creffett/distfiles/xmind-icons.tar.xz"
LICENSE="EPL-1.0 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=virtual/jre-1.5
	x11-libs/gtk+:2
"

S=${WORKDIR}

QA_PRESTRIPPED="opt/xmind/XMind/libcairo-swt.so"
QA_FLAGS_IGNORED="
	opt/xmind/Commons/plugins/org.eclipse.equinox.launcher.gtk.linux.x86_64_1.1.200.v20120522-1813/eclipse_1502.so
	opt/xmind/Commons/plugins/org.eclipse.equinox.launcher.gtk.linux.x86_1.1.200.v20120522-1813/eclipse_1502.so
	opt/xmind/XMind/libcairo-swt.so
	opt/xmind/XMind/XMind
"

src_configure() {
	if use amd64; then
		XDIR="XMind_Linux_64bit"
	else
		XDIR="XMind_Linux"
	fi
	mv "$XDIR" XMind || die
	mv XMind/.eclipseproduct Commons || die
	cp "${FILESDIR}"/${PN}-3.4.0-config.ini Commons/configuration || die #Combined common+linux config.ini
	# force data instance & config area to be at home/.xmind directory
	sed -i -e '/-configuration/d' \
		-e '/\.\/configuration/d' \
		-e '/-data/d' \
        -e '/\.\.\/Commons\/data\/workspace-cathy/d' \
		-e 's/\.\.\/Commons/\/opt\/xmind\/Commons/g' XMind/XMind.ini || die
	echo '-Dosgi.instance.area=@user.home/.xmind/workspace-cathy' >> XMind/XMind.ini || die
	echo '-Dosgi.configuration.area=@user.home/.xmind/configuration-cathy' >> XMind/XMind.ini || die
}

src_compile() {
	:
}

src_install() {
	insinto /opt/xmind
	doins -r Commons XMind || die
	fperms a+rx  "/opt/xmind/XMind/XMind"

	dodir /opt/bin
	exeinto /opt/bin
	newexe "${FILESDIR}/xmind-wrapper" xmind

	# install icons
	local res
	for res in 16 32 48; do
		newicon -s ${res} "${WORKDIR}/xmind-icons/xmind.${res}.png" xmind.png
	done

	# make desktop entry
	make_desktop_entry "xmind %F" XMind xmind Office "MimeType=application/x-xmind;"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	elog "For audio notes support, install media-sound/lame"
}

pkg_postrm() {
	gnome2_icon_cache_update
}
